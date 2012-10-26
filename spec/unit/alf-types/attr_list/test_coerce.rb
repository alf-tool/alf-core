require 'spec_helper'
module Alf
  describe AttrList, "coerce" do

    subject{ AttrList.coerce(arg) }

    let(:expected){ AttrList.new [:a, :b] }

    describe "with an AttrList" do
      let(:arg){ AttrList.new [:a, :b] }

      it{ should be(arg) }
    end

    describe "with a list of Symbols" do
      let(:arg){ [:a, :b] }

      it{ should eq(expected) }
    end

    describe "with a Hash" do
      let(:arg){ {a: 12, b: "Smith"} }

      it{ should eq(expected) }
    end

    describe "with a Hash to be symbolized" do
      let(:arg){ {'a' => 12, 'b' => "Smith"} }

      it{ should eq(expected) }
    end

    describe "with an Ordering" do
      let(:arg){ Ordering.new [[:a, :asc], [:b, :asc]] }

      it{ should eq(expected) }
    end

    describe "with a TupleComputation" do
      let(:arg){ TupleComputation[a: 12, b: "Smith"] }

      it{ should eq(expected) }
    end

    describe "when passed an unrecognized argument" do
      let(:arg){ false }
      specify{
        lambda{ subject }.should raise_error(TypeError)
      }
    end

    describe 'the [] alias' do

      it 'allows an empty list' do
        AttrList[].should eq(AttrList::EMPTY)
      end

      it 'allows a singleton literal list' do
        AttrList[:name].should eq(AttrList.new([:name]))
      end

      it 'allows a non-empty literal list' do
        AttrList[:name, :city].should eq(AttrList.new([:name, :city]))
      end
    end

  end
end
