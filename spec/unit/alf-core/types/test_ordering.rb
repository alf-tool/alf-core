require 'spec_helper'
module Alf
  describe Ordering do

    describe "the class itself" do
      let(:type){ Ordering }
      def Ordering.exemplars
        [
          [],
          [:a],
          [[:a, :asc], [:b, :asc]]
        ].map{|x| Ordering.coerce(x)}
      end
      it_should_behave_like 'A valid type implementation'
    end

    describe "coerce" do

      let(:expected){ Ordering.new([[:a, :asc], [:b, :asc]]) }

      it "should work with an Ordering" do
        key  = Ordering.coerce [:a, :b]
        key.should eq(expected)
      end

      it "should work with an empty array" do
        key  = Ordering.coerce []
        key.should eq(Ordering.new([]))
      end

      it "should work with a normalized array" do
        key = Ordering.coerce [[:a, :asc], [:b, :asc]]
        key.should eq(expected)
      end

      it "should work with an array of AttrName" do
        key = Ordering.coerce [:a, :b]
        key.should eq(expected)
      end

      it "should work with an array of Strings" do
        key = Ordering.coerce ["a", "b"]
        key.should eq(expected)
      end

      it "should work with a single array with explicit asc/desc (1)" do
        key = Ordering.coerce [:a, :asc]
        key.should eq(Ordering.new([[:a, :asc]]))
      end

      it "should work with a single array with explicit asc/desc (2)" do
        key = Ordering.coerce [:a, :asc, :b, :desc]
        key.should eq(Ordering.new([[:a, :asc], [:b, :desc]]))
      end

      it "should work with a single array with explicit asc/desc (3)" do
        key = Ordering.coerce ["a", "asc", "b", "desc"]
        key.should eq(Ordering.new([[:a, :asc], [:b, :desc]]))
      end

      it "should work with an AttrList" do
        key = Ordering.coerce(AttrList.new([:a, :b]))
        key.should eq(expected)
      end

    end # coerce

    describe "from_argv" do

      subject{ Ordering.from_argv(argv) }

      describe "on an empty array" do
        let(:argv){ [] }
        it{ should eq(Ordering.new([])) }
      end

      describe "on a singleton" do
        let(:argv){ ["hello"] }
        it{ should eq(Ordering.new([[:hello, :asc]])) }
      end

      describe "on multiple strings without explit directions" do
        let(:argv){ ["hello", "world"] }
        it{ should eq(Ordering.new([[:hello, :asc], [:world, :asc]])) }
      end

      describe "on multiple strings with explit directions" do
        let(:argv){ ["hello", "asc", "world", "desc"] }
        it{ should eq(Ordering.new([[:hello, :asc], [:world, :desc]])) }
      end

    end # from_argv

    describe "attributes" do

      it 'should work on an empty ordering' do
        Ordering.new([]).attributes.should eq([])
      end

      it 'should work on an singleton ordering' do
        Ordering.new([[:a, :asc]]).attributes.should eq([:a])
      end

      it 'should work on an ordering' do
        Ordering.new([[:a, :asc], [:b, :desc]]).attributes.should eq([:a, :b])
      end

    end # attributes

    describe "compare" do

      it "should work on a singleton ordering" do
        key = Ordering.coerce [:a]
        key.compare({:a => 1}, {:a => 2}).should == -1
        key.compare({:a => 1}, {:a => 1}).should == 0
        key.compare({:a => 2}, {:a => 1}).should == 1
      end

      it "should work on singleton when :desc" do
        key = Ordering.coerce [[:a, :desc]]
        key.compare({:a => 1}, {:a => 2}).should == 1
        key.compare({:a => 1}, {:a => 1}).should == 0
        key.compare({:a => 2}, {:a => 1}).should == -1
      end

      it "should work with multiple keys" do
        key = Ordering.coerce [[:a, :asc], [:b, :desc]]
        key.compare({:a => 1, :b => 1}, {:a => 0, :b => 1}).should == 1
        key.compare({:a => -1, :b => 1}, {:a => 0, :b => 1}).should == -1
        key.compare({:a => 0, :b => 1}, {:a => 0, :b => 0}).should == -1
        key.compare({:a => 1, :b => 1}, {:a => 1, :b => 2}).should == 1
        key.compare({:a => 1, :b => 1}, {:a => 1, :b => 1}).should == 0
      end

    end # compare

    describe "sorter" do

      let(:sorter){ Ordering.coerce([[:a, :desc]]).sorter }

      it 'should sort correctly' do
        [{:a => 2}, 
         {:a => 7}, 
         {:a => 1}].sort(&sorter).should eq([
           {:a => 7}, {:a => 2}, {:a => 1}
        ])
      end

    end # sorter

    describe "+" do

      subject{ Ordering.coerce(left) + right }
      let(:expected){ Ordering.new([[:a, :asc], [:b, :desc]]) }

      describe "with another Ordering" do
        let(:left){ [:a] }
        let(:right){ Ordering.new([[:b, :desc]]) }
        it{ should eq(expected) }
      end

      describe "with  another array" do
        let(:left){ [:a] }
        let(:right){ [[:b, :desc]] }
        it{ should eq(expected) }
      end

      describe "with  another array (2)" do
        let(:left){ [:a] }
        let(:right){ [:b, :desc] }
        it{ should eq(expected) }
      end

    end # +

    describe "to_attr_list" do

      it 'should return the correct list of attribute names' do
        Ordering.new([[:a, :asc], [:b, :desc]]).to_attr_list.should eq(AttrList[:a, :b])
      end

    end # "to_attr_list"

  end # Ordering
end # Alf
