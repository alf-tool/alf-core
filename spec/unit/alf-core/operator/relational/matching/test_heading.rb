require 'spec_helper'
module Alf
  module Operator::Relational
    describe Matching, 'heading' do

      let(:left){
        operand_with_heading(:id => Fixnum, :name => String)
      }
      let(:right){
        operand_with_heading(:id => Integer, :foo => String)
      }

      let(:op){ 
        a_lispy.matching(left, right)
      }
      subject{ op.heading }

      let(:expected){
        Heading[:id => Fixnum, :name => String]
      }

      it { should eq(expected) }

    end
  end
end
