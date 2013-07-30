require 'spec_helper'
module Alf
  describe Viewpoint, "members" do

    subject{ viewpoint.members }

    context 'on a base viewpoint' do
      let(:viewpoint){
        Module.new{
          include Alf::Viewpoint
          native :a_native_one
          def restricted
            restrict(a_native_one, id: 1)
          end
        }
      }

      it 'should have expected members' do
        subject.should eq([:a_native_one, :restricted])
      end
    end

  end
end
