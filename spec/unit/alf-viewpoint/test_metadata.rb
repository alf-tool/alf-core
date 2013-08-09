require 'spec_helper'
module Alf
  describe Viewpoint, "metadata" do

    subject{ viewpoint.metadata }

    let(:viewpoint){
      Module.new{
        include Viewpoint
      }
    }

    it 'should be a Metadata instance' do
      subject.should be_a(Viewpoint::Metadata)
    end

    it 'should always be the same on the same viewpoint' do
      subject.should be(viewpoint.metadata)
    end

    it 'should be different that metadata from other viewpoints' do
      other = Module.new{ include Viewpoint }
      subject.should_not be(other.metadata)
    end

  end
end
