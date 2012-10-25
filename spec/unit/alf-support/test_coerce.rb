require 'spec_helper'
module Alf
  describe "Support#coerce" do

    it 'coerces integers without trouble' do
      Support.coerce("12", Integer).should eql(12)
    end

    it 'coerces Time without trouble' do
      Support.coerce("2012-05-11 12:00:00.000000+0200", Time).should be_a(Time)
    end

    it 'coerces DateTime without trouble' do
      Support.coerce("2012-05-11 12:00:00.000000+0200", DateTime).should be_a(DateTime)
    end

    it 'should raise a TypeError in case of error' do
      lambda{ 
        Support.coerce("abc", Integer)
      }.should raise_error(TypeError)
    end

  end
end
