require 'spec_helper'
module Alf
  module Operator::Relational
    describe Group, 'keys' do

      subject{ op.keys }

      context 'when keys are not split by the group' do
        let(:operand){
          an_operand.with_heading(:id => Integer, :name => String).
                     with_keys([ :id ])
        }

        context 'when a key is not part of the group' do
          let(:op){ 
            a_lispy.group(operand, [:name], :names)
          }

          it { should eq(Keys[ [:id] ]) }
        end

        context 'when a key is not part of the group and --allbut' do
          let(:op){ 
            a_lispy.group(operand, [:id], :names, :allbut => true)
          }

          it { should eq(Keys[ [:id] ]) }
        end

        context 'when a whole key is part of the group' do
          let(:op){ 
            a_lispy.group(operand, [:id], :ids)
          }

          it { should eq(Keys[ [:ids] ]) }
        end

        context 'when a whole key is part of the group and --allbut' do
          let(:op){ 
            a_lispy.group(operand, [:name], :ids, :allbut => true)
          }

          it { should eq(Keys[ [:ids] ]) }
        end
      end

      context 'when keys are split by the group' do
        let(:operand){
          an_operand.with_heading(:sid => Integer, :pid => Integer, :price => Float).
                     with_keys([ :sid, :pid ])
        }

        context '--no-allbut' do
          let(:op){
            a_lispy.group(operand, [:pid, :price], :parts)
          }

          it{ should eq(Keys[ [:sid] ]) }
        end

      end

    end
  end
end
