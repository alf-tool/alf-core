require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe ProjectionKey do

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
