require 'spec_helper'
module Alf
  describe "Tools#coerce" do

    it 'coerces integers without trouble' do
      Tools.coerce("12", Integer).should eql(12)
    end

    it 'coerces Time without trouble' do
      Tools.coerce("2012-05-11 12:00:00.000000+0200", Time).should be_a(Time)
    end

    it 'coerces DateTime without trouble' do
      Tools.coerce("2012-05-11 12:00:00.000000+0200", DateTime).should be_a(DateTime)
    end

    it 'should raise a Alf::CoercionError in case of error' do
      lambda{ 
        Tools.coerce("abc", Integer)
      }.should raise_error(Alf::CoercionError)
    end

  end
end
