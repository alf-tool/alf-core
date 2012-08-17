require 'spec_helper'
module Alf
  module Algebra
    describe Project, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String, :status => String).
                   with_keys([:id], [:name])
      }

      subject{ op.keys }

      context 'when conserving at least one key' do
        let(:op){ 
          a_lispy.project(operand, [:id, :status])
        }
        let(:expected){
          Keys[ [:id] ]
        }

        it { should eq(expected) }
      end

      context 'when conserving at least one key with --allbut' do
        let(:op){ 
          a_lispy.project(operand, [:name], :allbut => true)
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

      context 'when projecting all keys away through --allbut' do
        let(:op){ 
          a_lispy.project(operand, [:id, :name], :allbut => true)
        }
        let(:expected){
          Keys[ [:status] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
