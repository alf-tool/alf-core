require 'spec_helper'
module Alf
  module Relvar
    describe Memory, "affect" do

      let(:before){ Relation(id: [1, 2, 3, 4]) }
      let(:after) { Relation(id: [1, 3, 4]) }
      let(:rv)    { Memory.new(before) }

      subject{
        rv.delete(predicate)
      }

      context 'with a real Predicate' do
        let(:predicate){
          Alf::Predicate.eq(id: 2)
        }

        it 'is as expected' do
          subject
          rv.value.should eq(after)
        end
      end

      context 'with a Predicate to coerce' do
        let(:predicate){
          {id: 2}
        }

        it 'is as expected' do
          subject
          rv.value.should eq(after)
        end
      end

    end
  end
end
