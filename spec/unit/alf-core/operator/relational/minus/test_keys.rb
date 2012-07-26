require 'spec_helper'
module Alf
  module Operator::Relational
    describe Minus, 'keys' do

      let(:left){
        an_operand.with_heading(:id => Fixnum, :name => String).with_keys([ :id ])
      }
      let(:right){
        an_operand.with_heading(:id => Integer, :name => String)
      }

      let(:op){ 
        a_lispy.minus(left, right)
      }
      subject{ op.keys }

      let(:expected){
        Keys[ [:id] ]
      }

      it { should eq(expected) }

    end
  end
end
