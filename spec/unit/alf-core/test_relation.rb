require 'spec_helper'
module Alf
  describe Relation do

    let(:tuples){[
      {:sid => 'S1', :name => 'Smith', :status => 20, :city => 'London'},
      {:sid => 'S2', :name => 'Jones', :status => 10, :city => 'Paris'},
      {:sid => 'S3', :name => 'Blake', :status => 30, :city => 'Paris'}
    ]}
    let(:tuples2){ tuples.sort{|t1,t2| t1[:name] <=> t2[:name]} }

    let(:rel1){ Relation.coerce(tuples) }
    let(:rel2){ Relation.coerce(tuples2) }
    let(:rel3){ Relation.coerce(tuples[0..1]) }

    it "should have a cardinality method" do
      rel1.cardinality.should == 3
    end

    it "should have an empty? method" do
      Alf::Relation[].should be_empty
      rel1.should_not be_empty
    end

    it "should define == correctly" do
      rel1.should == rel2
      rel2.should == rel1
      rel3.should_not == rel1
    end

    it "should allow putting them in hashes" do
      h = {}
      h[rel1] = 1
      h[rel2] = 2
      h[rel3] = 3
      h.size.should == 2
      h[rel1].should == 2
    end

    describe "rel1" do
      subject{ rel1 }
      it_should_behave_like "A value"
    end

    specify "different empty relations instances should be equal" do
      Relation.new(Set.new).should eq(Relation.new(Set.new))
      Relation[{}].should eq(Relation[{}])
    end

    describe "DUM" do
      subject{ Relation::DUM }
      it_should_behave_like "A value"
      specify{
        subject.cardinality.should == 0
        subject.to_a.should == []
        subject.should be_empty
      }
    end

    describe "DEE" do
      subject{ Relation::DEE }
      it_should_behave_like "A value"
      specify{
        subject.cardinality.should == 1
        subject.to_a.should == [Tuple.new({})]
        subject.should_not be_empty
      }
    end

  end
end