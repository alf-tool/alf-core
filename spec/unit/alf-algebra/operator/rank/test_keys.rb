require 'spec_helper'
module Alf
  module Algebra
    describe Rank, 'keys' do

      let(:operand){
        an_operand.with_heading(id: Integer, name: String, hobby: Tuple[name: String]).with_keys([:id])
      }

      subject{ op.keys }

      context 'when the order relation does not contain a key' do
        let(:op){ 
          a_lispy.rank(operand, [[:name, :asc]], :rank)
        }
        let(:expected){
          Keys[ [:id] ]
        }

        it { should eq(expected) }
      end

      context 'when the order relation does contain a key' do
        let(:op){ 
          a_lispy.rank(operand, [[[:hobby, :name], :asc], [:id, :desc]], :rank)
        }
        let(:expected){
          Keys[ [:id], [:rank] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
