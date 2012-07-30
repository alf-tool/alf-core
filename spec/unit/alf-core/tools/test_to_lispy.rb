require 'spec_helper'
module Alf
  describe Tools, ".to_lispy" do

    it "should have a valid example" do
      expr = examples_database.parse{
       (project :suppliers, [:name])
      }
      Tools.to_lispy(expr).should eq("(project :suppliers, [:name])")
    end

    subject{ Tools.to_lispy(value) }

    describe "on a Relvar" do
      let(:value){ examples_database.relvar(:suppliers) }
      it { should eq("suppliers") }
    end

    describe "on an AttrName" do
      let(:value){ :city }
      it { should eq(":city") }
    end

    describe "on an AttrList" do
      let(:value){ AttrList.new([:name, :city]) }
      it { should eq("[:name, :city]") }
    end

    describe "on a Heading" do
      let(:value){ Heading.new(:name => String) }
      it { should eq("{:name => String}") }
    end

    describe "on an Ordering" do
      let(:value){ Ordering.new([[:name, :asc], [:city, :desc]]) }
      it { should eq("[[:name, :asc], [:city, :desc]]") }
    end

    describe "on a Renaming" do
      let(:value){ Renaming.new(:old => :new) }
      it { should eq("{:old => :new}") }
    end

    describe "on an Aggregation" do
      let(:value){ Aggregator.coerce("sum{ qty*price }") }
      it { should eq("sum{ qty*price }") }
    end

    describe "on a TupleExpression" do
      let(:value){ TupleExpression.coerce(arg) }

      describe "When built from a string" do
        let(:arg){ "status.upcase" }
        it{ should eq("->{ status.upcase }")}
      end

      describe "When built from a symbol" do
        let(:arg){ :status }
        it{ should eq("->{ status }")}
      end

    end # TupleExpression

    describe "on a Predicate" do
      let(:value){ Predicate.coerce(arg) }

      describe "When built from a boolean" do
        let(:arg){ true }
        it{ should eq("->{ true }")}
      end

      describe "When built from a String" do
        let(:arg){ "status > 10" }
        it{ should eq("->{ status > 10 }")}
      end

      describe "When built from a Hash" do
        let(:arg){ {:status => 10} }
        it{ should eq("->{ self.status == 10 }")}
      end

    end # Predicate

    describe "on a TupleComputation" do
      let(:value){ TupleComputation.coerce(arg) }

      describe "When built from a Hash" do
        let(:arg){ {"upcased" => "status.upcase"} }
        it{ should eq("{:upcased => ->{ status.upcase }}")}
      end

    end # TupleComputation

    describe "on a Summarization" do
      let(:value){ Summarization.coerce(arg) }

      describe "When built from an Array" do
        let(:arg){ {"total" => "sum{ qty*price }"} }
        it{ should eq("{:total => sum{ qty*price }}") }
      end

    end # Summarization

    describe "on a VarRef" do
      let(:value){ Operator::VarRef.new(nil, :suppliers) }

      it{ should eq("suppliers") }
    end # VarRef

    let(:conn){ examples_database }

    describe "on an nullary operator" do
      let(:value){
        conn.parse{ generator(10, :id) }
      }
      it { should eq("(generator 10, :id)") }
    end

    describe "on an monadic operator with an option" do
      let(:value){
        conn.parse{ project(:suppliers, [:city], :allbut => true) }
      }
      it { should eq("(project :suppliers, [:city], {:allbut => true})") }
    end

    describe "on an monadic operator with default values for options" do
      let(:value){
        conn.parse{ project(:suppliers, [:city]) }
      }
      it { should eq("(project :suppliers, [:city])") }
    end

    describe "on an dyadic operator without no args nor any option" do
      let(:value){
        conn.parse{ join(:suppliers, :cities) }
      }
      it { should eq("(join :suppliers, :cities)") }
    end

  end
end
