require 'spec_helper'
module Alf
  module Algebra
    describe Rename, 'heading' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String)
      }
      let(:op){ 
        a_lispy.rename(operand, :name => :foo)
      }

      subject{ op.heading }

      let(:expected){
        Heading[:id => Integer, :foo => String]
      }

      it { should eq(expected) }

    end
  end
end
