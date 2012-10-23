require 'spec_helper'
module Alf
  module Algebra
    describe Ungroup, "keys" do

      let(:operand){
        an_operand.with_heading(
          :id    => Integer,
          :names => Relation[first: String, last: String]
        ).with_keys([:id])
      }
      let(:op){
        a_lispy.ungroup(operand, :names)
      }
      subject{ op.keys }

      it{
        should eq(Keys[ [:id, :first, :last] ])
      }

    end
  end
end