require 'spec_helper'
module Alf
  module Algebra
    describe Hierarchize, "heading" do

      let(:base){
        {id: Integer, parent: Integer, city: String}
      }
      let(:operand){
        an_operand.with_heading(base)
      }
      let(:op){
        a_lispy.hierarchize(operand, :id, :parent, :as)
      }
      subject{ op.heading }

      it{
        should eq(Relation.type(base){|r| {:as => r} }.heading)
      }

    end
  end
end