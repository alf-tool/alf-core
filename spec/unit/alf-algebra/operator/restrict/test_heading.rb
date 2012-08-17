require 'spec_helper'
module Alf
  module Algebra
    describe Restrict, 'heading' do

      let(:operand){
        an_operand.with_heading(:id => Fixnum, :name => String)
      }

      let(:op){ 
        a_lispy.restrict(operand, lambda{ true })
      }
      subject{ op.heading }

      let(:expected){
        Heading[:id => Fixnum, :name => String]
      }

      it { should eq(expected) }

    end
  end
end
