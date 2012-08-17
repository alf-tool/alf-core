require 'spec_helper'
module Alf
  module Algebra
    describe Ungroup, "keys" do

      let(:operand){
        an_operand.with_heading(:id => Integer, :names => Relation).with_keys([:id])
      }
      let(:op){
        a_lispy.ungroup(operand, :names)
      }
      subject{ op.keys }

      it{
        pending "Relation Type must be implemented first" do
          should be_nil
        end
      }

    end
  end
end