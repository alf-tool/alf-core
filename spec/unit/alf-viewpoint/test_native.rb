require 'spec_helper'
module Alf
  describe Viewpoint, ".native" do

    let(:viewpoint){
      Module.new{
        include Alf::Viewpoint
        native :hello
        native :hello2, :native_hello2
      }
    }

    it 'uses the logical name when no physical name is provided' do
      viewpoint.parse{
        hello
      }.name.should eq(:hello)
    end

    it 'uses the physical name when provided' do
      viewpoint.parse{
        hello2
      }.name.should eq(:native_hello2)
    end

  end
end
