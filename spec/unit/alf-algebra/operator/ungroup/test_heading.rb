require 'spec_helper'
module Alf
  module Algebra
    describe Ungroup, "heading" do

      let(:operand){
        an_operand.with_heading(:id => Integer, :names => Relation)
      }
      let(:op){
        a_lispy.ungroup(operand, :names)
      }
      subject{ op.heading }

      it{
        pending "Relation Type must be implemented first" do
          should be_nil
        end
      }

    end
  end
end