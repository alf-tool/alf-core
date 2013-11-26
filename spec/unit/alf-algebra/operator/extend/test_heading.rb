require 'spec_helper'
module Alf
  module Algebra
    describe Extend, 'heading' do

      let(:operand){
        an_operand.with_heading(:name => String)
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

      context 'when types are known on tuple expressions' do
        let(:op){
          a_lispy.extend(operand, :computed => TupleExpression.new(lambda{ 12 }, nil, Integer))
        }
        let(:expected){
          Heading[:name => String, :computed => Integer]
        }

        it{ should eq(expected) }
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
