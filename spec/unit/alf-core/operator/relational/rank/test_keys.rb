require 'spec_helper'
module Alf
  module Operator::Relational
    describe Rank, 'keys' do

      let(:operand){
        an_operand.with_heading(:id => Integer, :name => String).with_keys([:id])
      }

      subject{ op.keys }

      context 'when the order relation does not contain a key' do
        let(:op){ 
          a_lispy.rank(operand, [[:name, :asc]], :rank)
        }
        let(:expected){
          [ AttrList[:id] ]
        }

        it { should eq(expected) }
      end

      context 'when the order relation does contain a key' do
        let(:op){ 
          a_lispy.rank(operand, [[:name, :asc], [:id, :desc]], :rank)
        }
        let(:expected){
          [ AttrList[:id], AttrList[:rank] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
