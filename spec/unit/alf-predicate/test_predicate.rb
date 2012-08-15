require 'spec_helper'
module Alf

  shared_examples_for "a predicate" do

    let(:x){ 12 }
    let(:y){ 13 }

    it 'can be compiled to valid ruby code' do
      code = subject.to_ruby_code
      got  = Kernel::eval code, binding
      msg  = "Expected `#{code}` to return truth value (#{subject.expr.inspect})"
      [ TrueClass, FalseClass ].should include(got.class), msg
    end

    it 'provides a proc for easy evaluation' do
      got = instance_exec(&subject.to_proc)
      [ TrueClass, FalseClass ].should include(got.class)
    end

    it 'can be negated easily' do
      (!subject).should be_a(Predicate)
    end

    it 'detects stupid AND' do
      (subject & Predicate.tautology).should be(subject)
    end

    it 'detects stupid OR' do
      (subject | Predicate.contradiction).should be(subject)
    end

    it 'has free variables' do
      (fv = subject.free_variables).should be_a(AttrList)
      (fv - AttrList[ :x, :y ]).should be_empty
    end

    it 'always splits around and trivially when no free variables are touched' do
      top, down = subject.and_split(AttrList[:z])
      top.should be_tautology
      down.should eq(subject)
    end

  end

  describe 'Predicate.tautology' do
    subject{ Predicate.tautology }

    it_should_behave_like "a predicate"
  end

  describe 'Predicate.contradiction' do
    subject{ Predicate.contradiction }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.comp" do
    subject{ Predicate.comp(:lt, {:x => 2}) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.in" do
    subject{ Predicate.in(:x, [2, 3]) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.eq" do
    subject{ Predicate.eq(:x, 2) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.neq" do
    subject{ Predicate.neq(:x, 2) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.gt" do
    subject{ Predicate.gt(:x, 2) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.gte" do
    subject{ Predicate.gte(:x, 2) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.lt" do
    subject{ Predicate.lt(:x, 2) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.lte" do
    subject{ Predicate.lte(:x, 2) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.between" do
    subject{ Predicate.between(:x, 2, 3) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.and" do
    subject{ Predicate.and(Predicate.eq(:x, 12), Predicate.eq(:y, 12)) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.or" do
    subject{ Predicate.or(Predicate.eq(:x, 12), Predicate.eq(:y, 12)) }

    it_should_behave_like "a predicate"
  end

  describe "Predicate.not" do
    subject{ Predicate.not(Predicate.in(:x, [12])) }

    it_should_behave_like "a predicate"
  end

end
  