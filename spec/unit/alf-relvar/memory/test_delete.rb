require 'spec_helper'
module Alf
  class Relvar
    describe Memory, "delete" do

      let(:context){ examples_database }

      let(:value){ Relation(:id => 1) }

      let(:relvar){ Relvar::Memory.new(context, value) }

      subject{
        relvar.delete
      }

      before do
        relvar.value.should eq(value)
      end

      it 'should remove all tuples' do
        subject
        relvar.value.should eq(Alf::Relation::DUM)
      end

    end
  end
end