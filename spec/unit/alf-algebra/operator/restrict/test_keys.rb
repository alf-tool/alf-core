require 'spec_helper'
module Alf
  module Algebra
    describe Restrict, 'keys' do

      subject{ op.keys }

      context 'when the restriction does not touches existing keys' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id])
        }
        let(:op){
          a_lispy.restrict(operand, lambda{ true })
        }
        let(:expected){
          Keys[ [:id] ]
        }

        it { should eq(expected) }
      end

      context 'when the restriction touches part of a key' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id, :name])
        }
        let(:op){
          a_lispy.restrict(operand, Predicate.eq(:id, 12))
        }
        let(:expected){
          Keys[ [:name] ]
        }

        it { should eq(expected) }
      end

      context 'when the restriction touches a full key' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id, :name])
        }
        let(:op){
          a_lispy.restrict(operand, Predicate.eq(:id, 12) & Predicate.eq(:name, "Smith"))
        }
        let(:expected){
          Keys[ [] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
