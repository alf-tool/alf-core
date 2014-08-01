require 'spec_helper'
module Alf
  module Relvar
    describe Memory, "to_relation" do

      let(:value){ Relation(id: 1)   }
      let(:rv)   { Memory.new(value) }

      subject{ rv.to_relation }

      it 'is as expected' do
        subject.should be(value)
      end

    end
  end
end
