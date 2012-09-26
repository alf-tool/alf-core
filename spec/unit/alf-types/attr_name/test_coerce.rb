require 'spec_helper'
module Alf
  describe AttrName, "coerce" do

    it 'should work on valid attribute names' do
      AttrName.coerce("city").should eq(:city)
      AttrName.coerce(:big?).should eq(:big?)
    end

    it 'should raise ArgumentError otherwise' do
      lambda{ AttrName.coerce("!123")  }.should raise_error(Myrrha::Error)
      lambda{ AttrName.coerce(:'!123') }.should raise_error(Myrrha::Error)
    end

  end
end
