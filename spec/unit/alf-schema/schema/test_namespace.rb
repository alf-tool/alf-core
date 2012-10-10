require 'spec_helper'
module Alf
  describe Schema, ".namespace" do

    let(:subschema){
      superschema = Module.new{
        include Alf::Schema
        native :hello, :native_hello
      }
      Module.new{
        include Alf::Schema
        namespace :sub, superschema
      }
    }

    it 'allows accessing superschemas methods through the prefix' do
      subschema.parse{
        sub.hello
      }.name.should eq(:native_hello)
    end

  end
end
