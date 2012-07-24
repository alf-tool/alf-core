require 'spec_helper'
module Alf
  module Operator::Relational
    describe Extend, 'heading' do

      let(:operand){
        operand_with_heading(:name => String)
      }
      let(:op){ 
        a_lispy.extend(operand, :computed => lambda{ 12 })
      }

      subject{ op.heading }

      context 'with proper expression analysis' do
        let(:expected){
          Heading[:name => String, :computed => Integer]
        }

        it { 
          pending "type inference on expressions not implemented" do
            should eq(expected)
          end
        }
      end

      context 'with current expression analysis' do
        let(:expected){
          Heading[:name => String, :computed => Object]
        }

        it { should eq(expected) }
      end

    end
  end
end
