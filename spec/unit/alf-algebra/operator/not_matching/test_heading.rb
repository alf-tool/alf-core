require 'spec_helper'
module Alf
  module Algebra
    describe NotMatching, 'heading' do

      let(:left){
        an_operand.with_heading(:id => Fixnum, :name => String)
      }
      let(:right){
        an_operand.with_heading(:id => Integer, :foo => String)
      }

      let(:op){ 
        a_lispy.not_matching(left, right)
      }
      subject{ op.heading }

      let(:expected){
        Heading[:id => Fixnum, :name => String]
      }

      it { should eq(expected) }

    end
  end
end
