require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Sort, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String).
                   with_keys([ :id ])
      }

      subject{ op.keys }

      let(:op){ 
        a_lispy.sort(operand, [:id, :desc])
      }
      let(:expected){
        [ AttrList[ :id ] ]
      }

      it { should eq(expected) }

    end
  end
end
