require 'spec_helper'
module Alf
  describe "Tools#coerce" do

    it 'should coerce integers without trouble' do
      Tools.coerce("12", Integer).should eql(12)
    end

    it 'should raise a Alf::CoercionError in case of error' do
      lambda{ 
        Tools.coerce("abc", Integer)
      }.should raise_error(Alf::CoercionError)
    end

  end
end
