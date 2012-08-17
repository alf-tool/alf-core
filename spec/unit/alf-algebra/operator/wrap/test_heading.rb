require 'spec_helper'
module Alf
  module Algebra
    describe Wrap, 'heading' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String)
      }
      let(:expected){
        Heading[:id => Integer, :names => Hash]
      }

      subject{ op.heading }

      context '--no-allbut' do
        let(:op){ 
          a_lispy.wrap(operand, [:name], :names)
        }

        it { should eq(expected) }
      end

      context '--allbut' do
        let(:op){ 
          a_lispy.wrap(operand, [:id], :names, :allbut => true)
        }

        it { should eq(expected) }
      end

    end
  end
end
