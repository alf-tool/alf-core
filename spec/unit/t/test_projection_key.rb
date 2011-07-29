require 'spec_helper'
module Alf
  describe ProjectionKey do

    describe "coerce" do
      
      subject{ ProjectionKey.coerce(arg) }
      
      describe "when passed a ProjectionKey" do
        let(:arg){ [:a, :b] } 
        it{ should eq(ProjectionKey.new(arg)) }
      end
      
      describe "when passed an array" do
        let(:arg){ [:a, :b] }
        specify{
          subject.attributes.should eq([:a, :b])
        }
      end

      describe "when passed an OrderingKey" do
        let(:arg){ OrderingKey.new [[:a, :asc], [:b, :asc]] }
        it{ should eq(ProjectionKey.new([:a, :b])) }
      end

    end
    
    describe "from_argv" do
      
      subject{ ProjectionKey.from_argv(argv) }
      
      describe "on an empty array" do
        let(:argv){ [] }
        it{ should eq(ProjectionKey.new([])) }
      end
      
      describe "on a singleton" do
        let(:argv){ ["hello"] }
        it{ should eq(ProjectionKey.new([:hello])) }
      end
      
      describe "on multiple strings" do
        let(:argv){ ["hello", "world"] }
        it{ should eq(ProjectionKey.new([:hello, :world])) }
      end
        
    end

    describe "to_ordering_key" do

      specify "when passed an array" do
        key = ProjectionKey.coerce [:a, :b]
        okey = key.to_ordering_key
        okey.attributes.should == [:a, :b]
        okey.order_of(:a).should == :asc
        okey.order_of(:b).should == :asc
      end

    end

    describe "split" do 

      subject{ key.split(tuple, allbut) }

      describe "when used without allbut" do
        let(:key){ ProjectionKey.new [:a, :b] }
        let(:allbut){ false }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ [{:a => 1, :b => 2}, {:c => 3}] }
        it{ should == expected }
      end   

      describe "when used with allbut" do
        let(:key){ ProjectionKey.new [:a, :b] }
        let(:allbut){ true }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ [{:c => 3}, {:a => 1, :b => 2}] }
        it{ should == expected }
      end   

    end

    describe "project" do 

      subject{ key.project(tuple, allbut) }

      describe "when used without allbut" do
        let(:key){ ProjectionKey.new [:a, :b] }
        let(:allbut){ false }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ {:a => 1, :b => 2} }
        it{ should == expected }
      end   

      describe "when used with allbut" do
        let(:key){ ProjectionKey.new [:a, :b] }
        let(:allbut){ true }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ {:c => 3} }
        it{ should == expected }
      end   

    end

  end
end