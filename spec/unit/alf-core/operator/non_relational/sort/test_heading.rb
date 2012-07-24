require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Sort, 'heading' do

      let(:operand){
        operand_with_heading(:id => Integer, :name => String)
      }

      subject{ op.heading }

      let(:op){ 
        a_lispy.sort(operand, [:id, :desc])
      }
      let(:expected){
        Heading[:id => Integer, :name => String]
      }

      it { should eq(expected) }

    end
  end
end
