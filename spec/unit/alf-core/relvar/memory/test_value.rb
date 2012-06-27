require 'spec_helper'
module Alf
  class Relvar
    describe Memory, "value" do

      let(:context){ examples_database }

      subject{
        relvar.value
      }

      describe 'the default one' do
        let(:relvar){ Relvar::Memory.new(context, :suppliers) }

        it{ should eq(Alf::Relation::DUM) }
      end

      describe 'when specified at construction' do
        let(:value){ Relation(:id => 1) }
        let(:relvar){ Relvar::Memory.new(context, :suppliers, value) }

        it{ should eq(value) }
      end
      
    end
  end
end