require 'spec_helper'
module Alf
  module Algebra
    describe Ungroup, "heading" do

      let(:operand){
        an_operand.with_heading(id: Integer, names: Relation[name: String])
      }
      let(:op){
        a_lispy.ungroup(operand, :names)
      }
      subject{ op.heading }

      it{
        should eq(Heading[id: Integer, name: String])
      }

    end
  end
end