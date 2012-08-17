require 'spec_helper'
module Alf
  describe "Support#to_tuple" do

    let(:expected){
      {:name => "Alf"}
    }

    def to_tuple(x, &bl)
      Tuple(x, &bl) # Tuple(...) -> Alf::Tuple(...) -> Support.to_tuple(...)
    end

    it 'returns a tuple already' do
      to_tuple(:name => "Alf").should eq(expected)
    end

    it 'symbolizes keys' do
      to_tuple('name' => "Alf").should eq(expected)
    end

    it 'supports a block' do
      to_tuple('name' => "alf", 'version' => "foo"){|k,v|
        k.should be_a(Symbol)
        [k, v.upcase]
      }.should eq(:name => "ALF", :version => "FOO")
    end

    it 'yields Tuple-extended hashes' do
      to_tuple(:name => "Alf").should be_a(Alf::Tuple)
    end

  end
end
