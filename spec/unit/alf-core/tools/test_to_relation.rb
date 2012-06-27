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

    it 'converts a list of quantities to a Relation' do
      tuple    = {:qty => [10, 20]}
      expected = Relation.new(Set.new << {:qty => 10} << {:qty => 20})
      to_rel(tuple).should eq(expected)
    end

    it 'converts an array of tuples' do
      to_rel(expected.to_a).should eq(expected)
    end

    it 'symbolize keys on a single Hash' do
      tuple = {"name" => "Alf"}
      to_rel(tuple).should eq(expected)
    end

    it 'symbolize keys on a list of values' do
      tuple    = {"name" => ["Alf", "Myrrha"]}
      expected = Relation.new(Set.new << {:name => "Alf"} << {:name => "Myrrha"})
      to_rel(tuple).should eq(expected)
    end

    it 'symbolize keys on an array of hashes' do
      tuples = [{"name" => "Alf"}]
      to_rel(tuples).should eq(expected)
    end

    context 'when based on files' do
      let(:path){ Path.dir/'to_relation.rash' }
      before do
        path.write("{:name => 'Alf'}")
      end
      after do
        path.unlink rescue nil
      end
      it 'loads a Path object' do
        to_rel(path).should eq(expected)
      end
      it 'loads an IO' do
        path.open('r') do |io|
          to_rel(io).should eq(expected)
        end
      end
    end

  end
end
