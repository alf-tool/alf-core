require 'spec_helper'
module Alf
  describe AttrList do

    describe "coerce" do
      
      subject{ AttrList.coerce(arg) }
      
      describe "when passed a AttrList" do
        let(:arg){ [:a, :b] } 
        it{ should eq(AttrList.new(arg)) }
      end
      
      describe "when passed an array" do
        let(:arg){ [:a, :b] }
        specify{
          subject.attributes.should eq([:a, :b])
        }
      end

      describe "when passed an Ordering" do
        let(:arg){ Ordering.new [[:a, :asc], [:b, :asc]] }
        it{ should eq(AttrList.new([:a, :b])) }
      end

    end
    
    describe "from_argv" do
      
      subject{ AttrList.from_argv(argv) }
      
      describe "on an empty array" do
        let(:argv){ [] }
        it{ should eq(AttrList.new([])) }
      end
      
      describe "on a singleton" do
        let(:argv){ ["hello"] }
        it{ should eq(AttrList.new([:hello])) }
      end
      
      describe "on multiple strings" do
        let(:argv){ ["hello", "world"] }
        it{ should eq(AttrList.new([:hello, :world])) }
      end
        
    end

    describe "to_ordering" do

      specify "when passed an array" do
        key = AttrList.coerce [:a, :b]
        okey = key.to_ordering
        okey.attributes.should == [:a, :b]
        okey.order_of(:a).should == :asc
        okey.order_of(:b).should == :asc
      end

    end

    describe "split" do 

      subject{ key.split(tuple, allbut) }

      describe "when used without allbut" do
        let(:key){ AttrList.new [:a, :b] }
        let(:allbut){ false }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ [{:a => 1, :b => 2}, {:c => 3}] }
        it{ should == expected }
      end   

      describe "when used with allbut" do
        let(:key){ AttrList.new [:a, :b] }
        let(:allbut){ true }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ [{:c => 3}, {:a => 1, :b => 2}] }
        it{ should == expected }
      end   

    end

    describe "project" do 

      subject{ key.project(tuple, allbut) }

      describe "when used without allbut" do
        let(:key){ AttrList.new [:a, :b] }
        let(:allbut){ false }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ {:a => 1, :b => 2} }
        it{ should == expected }
      end   

      describe "when used with allbut" do
        let(:key){ AttrList.new [:a, :b] }
        let(:allbut){ true }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ {:c => 3} }
        it{ should == expected }
      end   

    end

  end
end