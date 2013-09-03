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
          private
          def a_private_member
          end
        }
      }

      it 'should have expected members' do
        subject.should eq([:a_native_one, :restricted])
      end
    end

    context 'on a viewpoint with expectations' do
      let(:viewpoint){
        base = Module.new{
          include Alf::Viewpoint
          native :a_member
          native :another_member
          private
          def a_private_member
          end
        }
        Module.new{
          include Alf::Viewpoint
          expects base
          def a_member
            restrict(super, foo: true)
          end
          def yet_another_one
            bar
          end
          private
          def another_private
          end
        }
      }

      it 'should have inherited members' do
        subject.should eq([:a_member, :another_member, :yet_another_one])
      end
    end

  end
end
