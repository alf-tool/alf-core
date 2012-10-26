require 'spec_helper'
module Alf
  module Algebra
    describe TypeCheck, 'keys' do

      let(:heading){
        {:id => Integer, :name => String}
      }
      let(:operand){
        an_operand.with_heading(heading).with_keys([ :id ])
      }

      subject{ op.keys }

      let(:op){ 
        a_lispy.type_safe(operand, heading)
      }
      let(:expected){
        Keys[ [ :id ] ]
      }

      it { should eq(expected) }

    end
  end
end
