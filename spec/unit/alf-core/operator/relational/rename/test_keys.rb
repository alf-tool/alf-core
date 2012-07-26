require 'spec_helper'
module Alf
  module Operator::Relational
    describe Rename, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String).with_keys([ :id ], [ :name ])
      }
      let(:op){ 
        a_lispy.rename(operand, :name => :foo)
      }

      subject{ op.keys }

      let(:expected){
        Keys[ [:id], [:foo] ]
      }

      it { should eq(expected) }

    end
  end
end
