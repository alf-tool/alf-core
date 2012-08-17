require 'spec_helper'
module Alf
  module Algebra
    describe Summarize, 'heading' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String)
      }

      subject{ op.heading }

      context '--no-allbut' do
        let(:op){ 
          a_lispy.summarize(operand, [:name], :sum => a_lispy.sum{ id })
        }
        let(:expected){
          Heading[:name => String, :sum => Object]
        }

        it { should eq(expected) }
      end

      context 'allbut' do
        let(:op){ 
          a_lispy.summarize(operand, [:name], {:sum => a_lispy.sum{ id }}, :allbut => true)
        }
        let(:expected){
          Heading[:id => Integer, :sum => Object]
        }

        it { should eq(expected) }
      end

    end
  end
end
