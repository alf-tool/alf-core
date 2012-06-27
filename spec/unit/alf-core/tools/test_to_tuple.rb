require 'spec_helper'
module Alf
  describe "Tools#to_tuple" do

    let(:expected){
      {:name => "Alf"}
    }

    def to_tuple(x)
      Tuple(x) # Tuple(...) -> Alf::Tuple(...) -> Tools.to_tuple(...)
    end

    it 'returns a tuple already' do
      to_tuple(:name => "Alf").should eq(expected)
    end

    it 'symbolizes keys' do
      to_tuple('name' => "Alf").should eq(expected)
    end

  end
end
