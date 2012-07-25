require 'spec_helper'
module Alf
  module Operator::Relational
    describe InferHeading, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String)
      }
      let(:op){ 
        a_lispy.infer_heading(operand)
      }

      subject{ op.keys }

      let(:expected){
        [ AttrList[] ]
      }

      it { should eq(expected) }

    end
  end
end
