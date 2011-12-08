require 'spec_helper'
module Alf
  module Engine
    describe Materialize::Hash do

      let(:operand){[
        {:name => "Smith", :city => "London"},
        {:name => "Jones", :city => "Paris"},
        {:name => "Smith", :city => "Athens"},
      ]}

      it 'should act as a normal cog' do
        op = Materialize::Hash.new(operand, AttrList[:name])
        op.to_set.should eq(operand.to_set)
      end

      it 'should allow allbut hashing' do
        op = Materialize::Hash.new(operand, AttrList[:city], true)
        op.to_set.should eq(operand.to_set)
      end

      it 'should have a each_pair method' do
        op = Materialize::Hash.new(operand, AttrList[:name])
        seen = []
        op.each_pair do |k,v|
          seen << [k,v]
        end
        seen.to_set.should eq([
          [{:name => "Smith"}, operand.select{|t| t[:name] == "Smith"}],
          [{:name => "Jones"}, operand.select{|t| t[:name] == "Jones"}]
        ].to_set)
      end

      describe "the indexed access" do

        it 'should return the expected tuples' do
          op = Materialize::Hash.new(operand, AttrList[:name])
          op[{:name => "Jones"}].to_a.should eq([
            {:name => "Jones", :city => "Paris"},
          ])
          op[{:name => "Smith"}].to_a.should eq([
            {:name => "Smith", :city => "London"},
            {:name => "Smith", :city => "Athens"},
          ])
          op[{:name => "NoSuchOne"}].to_a.should eq([])
        end

        it 'should allow late projection' do
          op = Materialize::Hash.new(operand, AttrList[:name])
          op[{:name => "Smith", :city => "London"}, true].to_a.should eq([
            {:name => "Smith", :city => "London"},
            {:name => "Smith", :city => "Athens"},
          ])
        end

        it 'late projection should work with allbut indexing' do
          op = Materialize::Hash.new(operand, AttrList[:city], true)
          op[{:name => "Smith", :city => "London"}, true].to_a.should eq([
            {:name => "Smith", :city => "London"},
            {:name => "Smith", :city => "Athens"},
          ])
        end

      end

    end
  end # module Engine
end # module Alf
