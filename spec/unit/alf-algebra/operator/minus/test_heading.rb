require 'spec_helper'
module Alf
  module Algebra
    describe Minus, 'heading' do

      let(:left){
        an_operand.with_heading(:id => Fixnum, :name => String)
      }
      let(:right){
        an_operand.with_heading(:id => Integer, :name => String)
      }

      let(:op){ 
        a_lispy.minus(left, right)
      }
      subject{ op.heading }

      let(:expected){
        Heading[:id => Fixnum, :name => String]
      }

      it { should eq(expected) }

    end
  end
end
