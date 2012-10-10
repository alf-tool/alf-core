require 'spec_helper'
module Alf
  describe Viewpoint, ".namespace" do

    let(:sub_vp){
      super_vp = Module.new{
        include Alf::Viewpoint
        native :hello, :native_hello
      }
      Module.new{
        include Alf::Viewpoint
        namespace :sub, super_vp
      }
    }

    it 'allows accessing super_vps methods through the prefix' do
      sub_vp.parse{
        sub.hello
      }.name.should eq(:native_hello)
    end

  end
end
