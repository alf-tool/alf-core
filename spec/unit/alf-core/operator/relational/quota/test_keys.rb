require 'spec_helper'
module Alf
  module Operator::Relational
    describe Quota, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String).with_keys([ :id ])
      }
      let(:op){ 
        a_lispy.quota(operand, [:id], [[:name, :asc]], :sum => a_lispy.sum{ id })
      }

      subject{ op.keys }

      let(:expected){
        [ AttrList[ :id ] ]
      }

      it { should eq(expected) }

    end
  end
end
