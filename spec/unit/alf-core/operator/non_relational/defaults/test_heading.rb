require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Defaults, 'heading' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String)
      }

      subject{ op.heading }

      context '--no-strict' do
        let(:op){ 
          a_lispy.defaults(operand, {:id => lambda{12}})
        }
        let(:expected){
          Heading[:id => String, :name => String]
        }

        it {
          pending "type inference on expressions not implemented" do
            should eq(expected)
          end
        }

        it{ should eq(Heading[:id => Object, :name => String]) }
      end

      context '--strict' do
        let(:op){ 
          a_lispy.defaults(operand, {:id => lambda{12}}, :strict => true)
        }
        let(:expected){
          Heading[:id => String]
        }

        it {
          pending "type inference on expressions not implemented" do
            should eq(expected)
          end
        }

        it{ should eq(Heading[:id => Object]) }
      end

    end
  end
end
