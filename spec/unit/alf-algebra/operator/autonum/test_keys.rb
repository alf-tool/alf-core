require 'spec_helper'
module Alf
  module Algebra
    describe Autonum, 'heading' do

      let(:operand){
        an_operand.with_keys([:name])
      }
      let(:op){ 
        a_lispy.autonum(operand, :auto)
      }
      let(:expected){
        Keys[[:name], [:auto]]
      }

      subject{ op.keys }

      it { should eq(expected) }

    end
  end
end
