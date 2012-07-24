require 'spec_helper'
module Alf
  module Operator::NonRelational
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
          [ AttrList[:id] ]
        }

        it { should eq(expected) }
      end

      context 'when projecting all keys away' do
        let(:op){ 
          a_lispy.clip(operand, [:status])
        }
        let(:expected){
          [ AttrList[:status] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
