require 'spec_helper'
module Alf
  module Algebra
    describe Project, 'keys' do

      subject{ op.keys }

      context 'with two single keys' do
        let(:operand){
          an_operand.with_heading(id: Integer, name: String, status: String, city: String).
                     with_keys([:id], [:name])
        }

        context 'when conserving at least one key' do
          let(:op){
            a_lispy.project(operand, [:id, :status])
          }
          let(:expected){
            Keys[ [:id] ]
          }

          it { should eq(expected) }
        end

        context 'when projecting all keys away' do
          let(:op){
            a_lispy.project(operand, [:status])
          }
          let(:expected){
            Keys[ [:status] ]
          }

          it { should eq(expected) }
        end
      end

      context 'when a key is cut' do
        # 1, 1, 1
        # 1, 2, 3
        let(:operand){
          an_operand.with_heading(sid: Integer, pid: Integer, qty: Integer)
                    .with_keys([:sid, :pid])
        }
        # 1, _, 1
        # 1, _, 3
        let(:op){
          a_lispy.project(operand, [:sid, :qty])
        }
        let(:expected){
          Keys[ [:sid, :qty] ]
        }

        it { should eq(expected) }
      end

      context 'when a key is projected due to a constant restriction' do
        # 1, 1, 1
        # 1, 2, 3
        let(:operand){
          an_operand.with_heading(sid: Integer, pid: Integer)
                    .with_keys([:sid, :pid])
        }
        # 1, _, 1
        let(:op){
          a_lispy.project(a_lispy.restrict(operand, pid: 1), [:sid, :qty])
        }
        let(:expected){
          Keys[ [:sid] ]
        }

        it { should eq(expected) }
      end

      context 'when a projection leads to an empty key' do
        ## 1, Jones
        let(:operand){
          an_operand.with_heading(sid: Integer, name: String)
                    .with_keys([:sid])
        }
        let(:op){
          a_lispy.project(a_lispy.restrict(operand, sid: 1), [:sid])
        }

        it { should eq(Keys[[]]) }
      end

    end
  end
end
