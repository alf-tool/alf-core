require 'spec_helper'
module Alf
  module Algebra
    describe TypeSafe, 'heading' do

      let(:heading){
        {:id => String, :name => String}
      }
      let(:operand){
        an_operand.with_heading(heading)
      }

      subject{ op.heading }

      let(:op){ 
        a_lispy.type_safe(operand, heading)
      }
      let(:expected){
        Heading[heading]
      }

      it { should eq(expected) }

    end
  end
end
