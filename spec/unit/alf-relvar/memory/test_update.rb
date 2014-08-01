require 'spec_helper'
module Alf
  module Relvar
    describe Memory, "update" do

      let(:before)   { Relation(id: [1, 2, 3, 4]) }
      let(:after)    { Relation(id: [1, 10, 3, 4]) }
      let(:updating) { {id: 10} }
      let(:predicate){ {id: 2}  }
      let(:rv)       { Memory.new(before) }

      subject{
        rv.update(updating, predicate)
      }

      it 'is as expected' do
        subject
        rv.value.should eq(after)
      end

    end
  end
end
