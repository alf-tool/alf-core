require 'spec_helper'
module Alf
  module Algebra
    describe Allbut, 'keys' do

      let(:operand){
        an_operand.with_heading(id: Integer, name: String, status: String).
                   with_keys([:id], [:name])
      }

      subject{ op.keys }

      context 'when conserving at least one key' do
        let(:op){
          a_lispy.allbut(operand, [:name])
        }
        let(:expected){
          Keys[ [:id] ]
        }

        it { should eq(expected) }
      end

      context 'when projecting all keys away through --allbut' do
        let(:op){
          a_lispy.allbut(operand, [:id, :name])
        }
        let(:expected){
          Keys[ [:status] ]
        }

        it { should eq(expected) }
      end

      context 'when a key is projected due to a constant restriction' do
        let(:operand){
          an_operand.with_heading(sid: Integer, pid: Integer)
                    .with_keys([:sid, :pid])
        }
        let(:op){
          a_lispy.allbut(a_lispy.restrict(operand, sid: 1), [:sid])
        }
        let(:expected){
          Keys[ [:pid] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
