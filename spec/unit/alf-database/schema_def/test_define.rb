require 'spec_helper'
module Alf
  class Database
    describe SchemaDef, 'define' do

      let(:schema){
        SchemaDef.new{ relvar :suppliers }
      }

      subject{ schema.define{ relvar :parts } }

      it 'installs the new relvars' do
        subject.relvars.should have_key(:parts)
      end

      it 'does not hide existing relvars' do
        subject.relvars.should have_key(:suppliers)
      end

    end
  end
end