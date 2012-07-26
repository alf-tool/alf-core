require 'spec_helper'
module Alf
  module Operator::Relational
    describe Matching, 'keys' do

      let(:op){ 
        a_lispy.matching(left, right)
      }
      subject{ op.keys }

      context 'when matching does not occurs on a right key' do
        let(:left){
          an_operand.with_heading(:id => Fixnum, :name => String).with_keys([ :id ])
        }
        let(:right){
          an_operand.with_heading(:id => Integer, :foo => String).with_keys([ :foo ])
        }

        let(:expected){
          Keys[ [:id] ]
        }

        it { should eq(expected) }
      end

      context 'when matching does occur on a right key' do
        let(:left){
          an_operand.with_heading(:id => Fixnum, :name => String).with_keys([ :name ])
        }
        let(:right){
          an_operand.with_heading(:id => Integer, :foo => String).with_keys([ :id ])
        }

        let(:expected){
          Keys[ [:name], [:id] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
