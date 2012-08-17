require 'spec_helper'
module Alf
  module Algebra
    describe Coerce, 'keys' do

      let(:operand){
        an_operand.with_keys([:id])
      }

      subject{ op.keys }

      let(:op){ 
        a_lispy.coerce(operand, :id => Integer)
      }
      let(:expected){
        Keys[ [:id] ]
      }

      it { should eq(expected) }

    end
  end
end
