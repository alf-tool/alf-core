require 'spec_helper'
module Alf
  describe AttrList, 'to_a' do
    
    it 'returns an array of symbols' do
      AttrList[:a, :b].to_a.should eq([:a, :b])
    end

    it 'works on empty list' do
      AttrList[].to_a.should eq([])
    end

  end
end
