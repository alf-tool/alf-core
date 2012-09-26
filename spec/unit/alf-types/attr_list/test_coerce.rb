require 'spec_helper'
module Alf
  describe AttrList, "coerce" do

    subject{ AttrList.coerce(arg) }

    describe "when passed an AttrList" do
      let(:arg){ AttrList.new [:a, :b] }
      it{ should be(arg) }
    end

    describe "when passed a a list of attribute names as Symbols" do
      let(:arg){ [:a, :b] } 
      it{ should eq(AttrList.new(arg)) }
    end

    describe "when passed an Ordering" do
      let(:arg){ Ordering.new [[:a, :asc], [:b, :asc]] }
      it{ should eq(AttrList.new([:a, :b])) }
    end

    describe "when passed a TupleComputation" do
      let(:arg){ TupleComputation[:a => 12, :b => "Smith"] }
      specify{ 
        subject.should be_a(AttrList) 
        subject.to_a.to_set.should eq([:a, :b].to_set)
      }
    end

    describe "when passed an unrecognized argument" do
      let(:arg){ :not_recognized }
      specify{
        lambda{ subject }.should raise_error(Myrrha::Error)
      }
    end

    describe 'the [] alias' do

      it 'should allow an empty list' do
        AttrList[].should eq(AttrList.new([]))
      end

      it 'should allow an non-empty list' do
        AttrList[:name, :city].should eq(AttrList.new([:name, :city]))
      end

    end

  end
end
