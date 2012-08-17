require 'spec_helper'
module Alf
  module Algebra
    describe Project, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String, :status => String).
                   with_keys([:id], [:name])
      }

      subject{ op.key_preserving? }

      context 'when conserving at least one key' do
        let(:op){ 
          a_lispy.project(operand, [:id, :status])
        }

        it { should be_true }
      end

      context 'when conserving at least one key with --allbut' do
        let(:op){ 
          a_lispy.project(operand, [:name], :allbut => true)
        }

        it { should be_true }
      end

      context 'when projecting all keys away' do
        let(:op){ 
          a_lispy.project(operand, [:status])
        }

        it { should be_false }
      end

      context 'when projecting all keys away through --allbut' do
        let(:op){ 
          a_lispy.project(operand, [:id, :name], :allbut => true)
        }

        it { should be_false }
      end

    end
  end
end
