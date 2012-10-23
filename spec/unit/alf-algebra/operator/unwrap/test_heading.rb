require 'spec_helper'
module Alf
  module Algebra
    describe Unwrap, "heading" do

      let(:operand){
        an_operand.with_heading(id: Integer, names: Tuple[name: String, status: Integer])
      }
      let(:op){
        a_lispy.unwrap(operand, :names)
      }
      subject{ op.heading }

      it{
       should eq(Heading.new(id: Integer, name: String, status: Integer))
      }

    end
  end
end