require 'spec_helper'
module Alf
  module Operator::Relational
    describe Restrict, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Fixnum, :name => String).with_keys([:id])
      }

      let(:op){ 
        a_lispy.restrict(operand, lambda{ true })
      }
      subject{ op.keys }

      let(:expected){
        [ AttrList[:id] ]
      }

      it { should eq(expected) }

    end
  end
end
