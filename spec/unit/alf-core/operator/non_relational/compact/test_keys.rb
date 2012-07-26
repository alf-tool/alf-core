require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Compact, 'keys' do

      subject{ op.keys }

      let(:op){ 
        a_lispy.compact(operand)
      }

      context 'when the operand has a key' do
        let(:operand){
          an_operand.with_heading(:id => String, :name => String).
                     with_keys([ :id ])
        }
        let(:expected){
          Keys[ [ :id ] ]
        }

        it { should eq(expected) }
      end

      context 'when the operand has no key' do
        let(:operand){
          an_operand.with_heading(:id => String, :name => String).
                     with_keys()
        }
        let(:expected){
          Keys[ [ :id, :name ] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
