require 'spec_helper'
module Alf
  describe OrderingKey do

    describe "coerce" do

      specify "when passed an doubly array" do
        key = OrderingKey.coerce [[:a, :asc], [:b, :desc]]
        key.attributes.should == [:a, :b]
        key.order_of(:a).should == :asc
        key.order_of(:b).should == :desc
      end

      specify "when passed a single array" do
        key = OrderingKey.coerce [:a, :b]
        key.attributes.should == [:a, :b]
        key.order_of(:a).should == :asc
        key.order_of(:b).should == :asc
      end

      specify "when passed a single array of strings" do
        key = OrderingKey.coerce ["a", "b"]
        key.attributes.should == [:a, :b]
        key.order_of(:a).should == :asc
        key.order_of(:b).should == :asc
      end

      specify "when passed a single array with asc and desc (1)" do
        key = OrderingKey.coerce [:a, :asc]
        key.attributes.should == [:a]
        key.order_of(:a).should == :asc
      end

      specify "when passed a single array with asc and desc (1)" do
        key = OrderingKey.coerce [:a, :asc, :b, :desc]
        key.attributes.should == [:a, :b]
        key.order_of(:a).should == :asc
        key.order_of(:b).should == :desc
      end

      specify "when passed a string array with asc and desc" do
        key = OrderingKey.coerce ["a", "asc", "b", "desc"]
        key.attributes.should == [:a, :b]
        key.order_of(:a).should == :asc
        key.order_of(:b).should == :desc
      end

      specify "when passed an ordering key" do
        key  = OrderingKey.coerce [:a, :b]
        key2 = OrderingKey.coerce key
        key.should == key2
      end

      specify "when passed a projection key" do
        pkey = AttrList.new [:a, :b]
        key = OrderingKey.coerce pkey
        key.attributes.should == [:a, :b]
        key.order_of(:a).should == :asc
        key.order_of(:b).should == :asc
      end

    end # coerce
    
    describe "from_argv" do
      
      subject{ OrderingKey.from_argv(argv) }
      
      describe "on an empty array" do
        let(:argv){ [] }
        it{ should eq(OrderingKey.new([])) }
      end
      
      describe "on a singleton" do
        let(:argv){ ["hello"] }
        it{ should eq(OrderingKey.new([[:hello, :asc]])) }
      end
      
      describe "on multiple strings" do
        let(:argv){ ["hello", "asc", "world", "desc"] }
        it{ should eq(OrderingKey.new([[:hello, :asc], [:world, :desc]])) }
      end
        
    end

    describe "compare" do
      
      specify "when passed a single key" do
        key = OrderingKey.coerce [:a]
        key.compare({:a => 1}, {:a => 2}).should == -1
        key.compare({:a => 1}, {:a => 1}).should == 0
        key.compare({:a => 2}, {:a => 1}).should == 1
      end 
      
      specify "when passed a single key with desc order" do
        key = OrderingKey.coerce [[:a, :desc]]
        key.compare({:a => 1}, {:a => 2}).should == 1
        key.compare({:a => 1}, {:a => 1}).should == 0
        key.compare({:a => 2}, {:a => 1}).should == -1
      end 

      specify "when passed a double key" do
        key = OrderingKey.coerce [[:a, :asc], [:b, :desc]]
        key.compare({:a => 1, :b => 1}, {:a => 0, :b => 1}).should == 1
        key.compare({:a => 1, :b => 1}, {:a => 1, :b => 2}).should == 1
        key.compare({:a => 1, :b => 1}, {:a => 1, :b => 1}).should == 0
      end 

    end

    describe "+" do

      specify "when passed another key" do
        key = OrderingKey.coerce [:a]
        key2 = key + OrderingKey.coerce([[:b, :desc]])
        key2.ordering.should == [[:a, :asc], [:b, :desc]]
      end

      specify "when passed another array" do
        key = OrderingKey.coerce [:a]
        key2 = key + [[:b, :desc]]
        key2.ordering.should == [[:a, :asc], [:b, :desc]]
      end

    end

  end
end