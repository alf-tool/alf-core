require 'spec_helper'
module Alf
  describe Viewpoint, "depends" do

    let(:viewpoint){
      Module.new{
        include Viewpoint
        depends :a, 1, 2
        depends :b, 3, 4
      }
    }

    it 'populates metadata' do
      viewpoint.metadata.dependencies.should eq(a: [1, 2], b: [3, 4])
    end

  end
end
