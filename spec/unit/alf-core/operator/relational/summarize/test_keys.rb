require 'spec_helper'
module Alf
  module Operator::Relational
    describe Summarize, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String).with_keys([ :id ])
      }

      subject{ op.keys }

      context 'when the by list does not has a key' do
        let(:op){ 
          a_lispy.summarize(operand, [:name], :sum => a_lispy.sum{ id })
        }
        let(:expected){
          [ AttrList[:name] ]
        }

        it { should eq(expected) }
      end

      context 'when the by list does not has a key (--allbut)' do
        let(:op){ 
          a_lispy.summarize(operand, [:id], {:sum => a_lispy.sum{ id }}, :allbut => true)
        }
        let(:expected){
          [ AttrList[:name] ]
        }

        it { should eq(expected) }
      end

      context 'when the by list is a superkey' do
        let(:op){ 
          a_lispy.summarize(operand, [:id, :name], :sum => a_lispy.sum{ id })
        }
        let(:expected){
          [ AttrList[:id] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
