require 'spec_helper'
module Alf
  module Operator::Relational
    describe Unwrap, "heading" do

      let(:operand){
        an_operand.with_heading(:id => Integer, :names => Hash)
      }
      let(:op){
        a_lispy.unwrap(operand, :names)
      }
      subject{ op.heading }

      it{
        pending "Tuple Type must be implemented first" do
          should be_nil
        end
      }

    end
  end
end