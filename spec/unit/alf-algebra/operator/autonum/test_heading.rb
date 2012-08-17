require 'spec_helper'
module Alf
  module Algebra
    describe Autonum, 'heading' do

      let(:operand){
        an_operand.with_heading(:name => String)
      }
      let(:op){ 
        a_lispy.autonum(operand, :auto)
      }
      let(:expected){
        Heading[:auto => Integer, :name => String]
      }

      subject{ op.heading }

      it { should eq(expected) }

    end
  end
end
