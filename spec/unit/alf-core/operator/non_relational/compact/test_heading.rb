require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Compact, 'heading' do

      let(:operand){
        an_operand.with_heading(:id => String, :name => String)
      }

      subject{ op.heading }

      let(:op){ 
        a_lispy.compact(operand)
      }
      let(:expected){
        Heading[:id => String, :name => String]
      }

      it { should eq(expected) }

    end
  end
end
