require 'spec_helper'
module Alf
  describe Schema, ".native" do

    let(:schema){
      Module.new{
        include Alf::Schema
        native :hello
        native :hello2, :native_hello2
      }
    }

    it 'uses the logical name when no physical name is provided' do
      schema.parse{
        hello
      }.name.should eq(:hello)
    end

    it 'uses the physical name when provided' do
      schema.parse{
        hello2
      }.name.should eq(:native_hello2)
    end

  end
end
