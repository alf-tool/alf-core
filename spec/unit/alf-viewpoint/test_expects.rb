require 'spec_helper'
module Alf
  describe Viewpoint, "expects" do

    let(:viewpoint){
      Module.new{
        include Viewpoint
        expects 1, 2
        expects 3
      }
    }

    it 'populates metadata' do
      viewpoint.metadata.expectations.should eq([1, 2, 3])
    end

  end
end
