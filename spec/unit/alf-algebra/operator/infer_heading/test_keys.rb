require 'spec_helper'
module Alf
  module Algebra
    describe InferHeading, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String)
      }
      let(:op){ 
        a_lispy.infer_heading(operand)
      }

      subject{ op.keys }

      let(:expected){
        Keys[ [] ]
      }

      it { should eq(expected) }

    end
  end
end
