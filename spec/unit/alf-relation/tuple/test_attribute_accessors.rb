require 'spec_helper'
module Alf
  module Types
    describe Tuple, "attribute accessors" do

      context 'when no conflict' do
        let(:tuple){ Tuple(:id => 1, :name => "Alf") }

        it 'has expected accessors' do
          tuple.id.should eq(1)
          tuple.name.should eq("Alf")
        end

        it 'does not confuse accessors and methods' do
          lambda{
            tuple.id("hello")
          }.should raise_error(NoMethodError)
        end
      end

      context 'when a conflict' do
        let(:tuple){ Tuple(:size => 23, :map => "Alf") }

        it 'gives priority to attributes' do
          tuple.size.should eq(23)
          tuple.map.should eq("Alf")
        end

        it 'does not confuse accessors and methods' do
          tuple.map{|x| "a value" }.should eq(["a value", "a value"])
        end
      end

    end
  end
end
