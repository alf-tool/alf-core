require 'spec_helper'
module Alf
  module Relvar
    describe Memory, "insert" do

      let(:before)  { Relation(id: [1, 2])    }
      let(:after)   { Relation(id: [1, 2, 3]) }
      let(:rv)      { Memory.new(before)      }

      subject{
        rv.insert(inserted)
      }

      context 'with a Relation' do
        let(:inserted){
          Relation(id: [3, 1])
        }

        it 'is as expected' do
          subject
          rv.value.should eq(after)
        end
      end

      context 'with some tuples' do
        let(:inserted){
          [{ id: 3 }, { id: 1 }]
        }

        it 'is as expected' do
          subject
          rv.value.should eq(after)
        end
      end

      context 'with one tuple' do
        let(:inserted){
          { id: 3 }
        }

        it 'is as expected' do
          subject
          rv.value.should eq(after)
        end
      end

    end
  end
end
