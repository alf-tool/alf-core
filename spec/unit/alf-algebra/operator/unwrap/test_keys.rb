require 'spec_helper'
module Alf
  module Algebra
    describe Unwrap, "keys" do

      let(:operand){
        an_operand.with_heading(:id => Integer, :names => Hash).with_keys([:id])
      }
      let(:op){
        a_lispy.unwrap(operand, :names)
      }
      subject{ op.keys }

      it{
        should eq(Keys[ [:id] ])
      }

    end
  end
end