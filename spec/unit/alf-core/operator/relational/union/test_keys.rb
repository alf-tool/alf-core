require 'spec_helper'
module Alf
  module Operator::Relational
    describe Union, 'keys' do

      let(:left){
        an_operand.with_heading(:id => Integer, :name => String)
      }
      let(:right){
        an_operand.with_heading(:id => Integer, :name => String)
      }
      let(:op){
        a_lispy.union(left, right)
      }

      subject{ op.keys }

      let(:expected){
        Keys[ [:id, :name] ]
      }

      it { should eq(expected) }

    end
  end
end
