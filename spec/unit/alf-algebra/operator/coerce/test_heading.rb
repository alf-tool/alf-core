require 'spec_helper'
module Alf
  module Algebra
    describe Coerce, 'heading' do

      let(:operand){
        an_operand.with_heading(:id => String, :name => String)
      }

      subject{ op.heading }

      let(:op){ 
        a_lispy.coerce(operand, :id => Integer)
      }
      let(:expected){
        Heading[:id => Integer, :name => String]
      }

      it { should eq(expected) }

    end
  end
end
