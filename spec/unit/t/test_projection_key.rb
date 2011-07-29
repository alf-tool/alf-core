require 'spec_helper'
module Alf
  describe ProjectionKey do

    describe "coerce" do
      
      specify "when passed an array" do
        key = ProjectionKey.coerce [:a, :b]
        key.attributes.should == [:a, :b]
      end

      specify "when passed a ProjectionKey" do
        key = ProjectionKey.coerce [:a, :b]
        key2 = ProjectionKey.coerce key
        key2.should == key
      end

      specify "when passed an OrderingKey" do
        okey = OrderingKey.new [[:a, :asc], [:b, :asc]]
        key = ProjectionKey.coerce(okey)
        key.attributes.should == [:a, :b]
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