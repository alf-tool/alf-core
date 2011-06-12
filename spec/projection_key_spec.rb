require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe ProjectionKey do

    describe "coerce" do
      
      specify "when passed an array" do
        key = ProjectionKey.coerce [:a, :b]
        key.attributes.should == [:a, :b]
        key.allbut.should == false
      end

      specify "when passed an OrderingKey" do
        okey = OrderingKey.new [[:a, :asc], [:b, :asc]]
        key = ProjectionKey.coerce(okey)
        key.attributes.should == [:a, :b]
        key.allbut.should == false
      end

    end

    describe "split" do 

      subject{ key.split(tuple) }

      describe "when used without allbut" do
        let(:key){ ProjectionKey.new [:a, :b] }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ [{:a => 1, :b => 2}, {:c => 3}] }
        it{ should == expected }
      end   

      describe "when used with allbut" do
        let(:key){ ProjectionKey.new [:a, :b], true }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ [{:c => 3}, {:a => 1, :b => 2}] }
        it{ should == expected }
      end   

    end

    describe "project" do 

      subject{ key.project(tuple) }

      describe "when used without allbut" do
        let(:key){ ProjectionKey.new [:a, :b] }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ {:a => 1, :b => 2} }
        it{ should == expected }
      end   

      describe "when used with allbut" do
        let(:key){ ProjectionKey.new [:a, :b], true }
        let(:tuple){ {:a => 1, :b => 2, :c => 3} }
        let(:expected){ {:c => 3} }
        it{ should == expected }
      end   

    end

  end
end
