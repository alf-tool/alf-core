require 'spec_helper'
module Alf
  class Database
    describe Schema, 'define' do

      let(:schema){
        Schema.new{ relvar :suppliers }
      }

      subject{ schema.define{ relvar :parts } }

      it 'installs the new relvars' do
        lambda{
          subject.instance_method(:parts)
        }.should_not raise_error(NameError)
      end

      it 'does not hide existing relvars' do
        lambda{
          subject.instance_method(:suppliers)
        }.should_not raise_error(NameError)
      end

    end
  end
end