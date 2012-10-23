require 'spec_helper'
module Alf
  describe "Support#to_tuple" do

    let(:expected){
      Tuple(name: "Alf")
    }

    def to_tuple(x, &bl)
      Tuple(x, &bl) # Tuple(...) -> Alf::Tuple(...) -> Support.to_tuple(...)
    end

    it 'returns a tuple already' do
      to_tuple(name: "Alf").should eq(expected)
    end

    it 'symbolizes keys' do
      to_tuple('name' => "Alf").should eq(expected)
    end

    it 'supports a block that is delegated to remap' do
      to_tuple('name' => "alf", 'version' => "foo"){|k,v|
        k.should be_a(Symbol)
        v.upcase
      }.should eq(Tuple(name: "ALF", version: "FOO"))
    end

  end
end
