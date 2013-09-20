require 'spec_helper'
module Alf
  module Engine
    describe Hierarchize do

      let(:type){
        Relation.type(id: Fixnum, parent: Fixnum, name: String){|r| {subs: r} }
      }

      let(:operand){[
        {id: 1, parent: 1, name: "USA"},
        {id: 5, parent: 3, name: "Brussels"},
        {id: 2, parent: 2, name: "Europe"},
        {id: 3, parent: 2, name: "Belgium"},
        {id: 4, parent: 2, name: "France"},
      ]}

      let(:expected){
        type.new([
          { id: 1, parent: 1, name: "USA",    subs: type.empty },
          { id: 2, parent: 2, name: "Europe", subs: type.new([
              { id: 3, parent: 2, name: "Belgium", subs: type.new([
                  {id: 5, parent: 3, name: "Brussels", subs: type.empty } ].to_set) },
              { id: 4, parent: 2, name: "France", subs: type.empty } ].to_set) }
        ].to_set)
      }

      subject{
        Hierarchize.new(operand, AttrList[:id], AttrList[:parent], :subs)
      }

      let(:resulting_relation){
        subject.to_relation
      }

      def are_equal(x, y)
        # same class
        x.class.should eq(y.class)

        # take tuples
        got = x.to_a.sort{|t,u| t[:id] <=> u[:id] }
        exp = y.to_a.sort{|t,u| t[:id] <=> u[:id] }
        
        # compare attributes
        got.zip(exp) do |e,f|
          [:id, :parent, :name].each do |a|
            e[a].should eq(f[a])
          end
          are_equal(e[:subs], f[:subs])
          e[:subs].to_set.should eq(f[:subs].to_set)
          e[:subs].should eq(f[:subs])
        end

        true
      end

      it 'has expected result type' do
        resulting_relation.class.should eq(type)
      end

      it 'has pair-wise equal tuples' do
        are_equal(resulting_relation, expected).should be_true
      end

      it 'computes expected relation' do
        resulting_relation.should eq(expected)
      end

    end
  end
end
