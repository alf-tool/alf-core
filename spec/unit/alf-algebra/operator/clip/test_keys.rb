require 'spec_helper'
module Alf
  module Algebra
    describe Clip, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String, :status => String).
                   with_keys([:id], [:name])
      }

      subject{ op.keys }

      context 'when conserving at least one key' do
        let(:op){ 
          a_lispy.clip(operand, [:id, :status])
        }
        let(:expected){
          Keys[ [:id] ]
        }

        it { should eq(expected) }
      end

      context 'when conserving at least one key (--allbut)' do
        let(:op){ 
          a_lispy.clip(operand, [:name], :allbut => true)
        }
        let(:expected){
          Keys[ [:id] ]
        }

        it { should eq(expected) }
      end

      context 'when projecting all keys away' do
        let(:op){ 
          a_lispy.clip(operand, [:status])
        }
        let(:expected){
          Keys[ [:status] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
