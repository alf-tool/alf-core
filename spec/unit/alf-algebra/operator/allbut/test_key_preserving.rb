require 'spec_helper'
module Alf
  module Algebra
    describe "Allbut", 'key_preserving?' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String, :status => String).
                   with_keys([:id], [:name])
      }

      subject{ op.key_preserving? }

      context 'when conserving at least one key' do
        let(:op){ 
          a_lispy.allbut(operand, [:name])
        }

        it { should be_true }
      end

      context 'when projecting all keys away' do
        let(:op){ 
          a_lispy.allbut(operand, [:id, :name])
        }

        it { should be_false }
      end

      context 'when the operand is a restriction on the key' do
        let(:operand){
          an_operand.with_heading(sid: Integer, name: String)
                    .with_keys([:sid])
        }
        let(:op){
          a_lispy.allbut(a_lispy.restrict(operand, sid: 1), [:name])
        }

        it { should be_true }
      end

      context 'when a key is projected due to a constant restriction' do
        let(:operand){
          an_operand.with_heading(sid: Integer, pid: Integer)
                    .with_keys([:sid, :pid])
        }
        let(:op){
          a_lispy.allbut(a_lispy.restrict(operand, sid: 1), [:sid])
        }

        it { should be_true }
      end

    end
  end
end
