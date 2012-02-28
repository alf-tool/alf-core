require 'spec_helper'
module Alf
  describe "Tools#to_relation" do

    let(:expected){
      Relation.new(Set.new << {:name => "Alf"})
    }

    def to_rel(x)
      Relation(x) # Relation(...) -> Alf::Relation(...) -> Tools.to_relation(...)
    end

    it 'delegates to to_relation if it exists' do
      x = Struct.new(:to_relation).new("Hello")
      to_rel(x).should eq("Hello")
    end

    it 'works on Relation' do
      to_rel(expected).should eq(expected)
      to_rel(expected).object_id.should eq(expected.object_id)
    end

    it 'converts a single Hash as a singleton relation' do
      tuple = {:name => "Alf"}
      to_rel(tuple).should eq(expected)
    end

    it 'converts a list of names values to a Relation' do
      tuple    = {:name => ["Alf", "Myrrha"]}
      expected = Relation.new(Set.new << {:name => "Alf"} << {:name => "Myrrha"})
      to_rel(tuple).should eq(expected)
    end

    it 'converts an array of tuples' do
      to_rel(expected.to_a).should eq(expected)
    end

  end
end
