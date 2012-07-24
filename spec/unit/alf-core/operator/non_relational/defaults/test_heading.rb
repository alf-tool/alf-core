require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Defaults, 'heading' do

      let(:operand){
        operand_with_heading(:id => Integer, :name => String)
      }

      subject{ op.heading }

      context '--no-strict' do
        let(:op){ 
          a_lispy.defaults(operand, {:id => 12})
        }
        let(:expected){
          Heading[:id => String, :name => String]
        }

        it {
          pending "TupleComputation#heading must be implemented first" do
            should eq(expected)
          end
        }
      end

      context '--strict' do
        let(:op){ 
          a_lispy.defaults(operand, {:id => 12}, :strict => true)
        }
        let(:expected){
          Heading[:id => String]
        }

        it {
          pending "TupleComputation#heading must be implemented first" do
            should eq(expected)
          end
        }
      end

    end
  end
end
