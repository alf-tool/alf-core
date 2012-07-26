require 'spec_helper'
module Alf
  module Operator::Relational
    describe Intersect, 'keys' do

      let(:left){
        an_operand.with_heading(:id => Integer, :name => String).
                   with_keys([ :id ])
      }

      subject{ op.keys }

      context 'when exactly same keys' do
        let(:right){
          an_operand.with_heading(:id => Integer, :name => String).
                     with_keys([ :id ])
        }
        let(:op){ 
          a_lispy.intersect(left, right)
        }

        it { should eq(Keys[ [:id] ]) }
      end

      context 'when exactly same keys but in different order' do
        let(:left){
          an_operand.with_heading(:id => Integer, :name => String).
                     with_keys([ :id, :name ])
        }
        let(:right){
          an_operand.with_heading(:id => Integer, :name => String).
                     with_keys([ :name, :id ])
        }
        let(:op){ 
          a_lispy.intersect(left, right)
        }

        it { should eq(Keys[ [:id, :name] ]) }
      end

      context 'when completely different keys' do
        let(:right){
          an_operand.with_heading(:id => Integer, :name => String).
                     with_keys([ :name ])
        }
        let(:op){ 
          a_lispy.intersect(left, right)
        }

        it { should eq(Keys[ [:id], [:name] ]) }
      end

      context 'when overlapping keys' do
        let(:right){
          an_operand.with_heading(:id => Integer, :name => String).
                     with_keys([ :id, :name ])
        }
        let(:op){ 
          a_lispy.intersect(left, right)
        }

        it { should eq(Keys[ [:id] ]) }
      end

    end
  end
end
