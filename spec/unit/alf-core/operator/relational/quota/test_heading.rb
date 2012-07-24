require 'spec_helper'
module Alf
  module Operator::Relational
    describe Quota, 'heading' do

      let(:operand){
        operand_with_heading(:id => Integer, :name => String)
      }
      let(:op){ 
        a_lispy.quota(operand, [:id], [[:name, :asc]], :sum => a_lispy.sum{ id })
      }

      subject{ op.heading }

      let(:expected){
        Heading[:id => Integer, :name => String, :sum => Object]
      }

      it { should eq(expected) }

    end
  end
end
