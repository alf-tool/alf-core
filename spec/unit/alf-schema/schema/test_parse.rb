require 'spec_helper'
module Alf
  describe Schema, "parse" do

    it 'allows parsing predicate expressions' do
      Schema.parse{
        tautology
      }.should eq(Predicate.tautology)
      Schema.parse{
        eq(:x, 2)
      }.should be_a(Predicate)
    end

    it 'allows parsing relational expressions' do
      Schema.parse{
        restrict(:suppliers, ->{ sid == 'S1' })
      }.should be_a(Algebra::Restrict)
    end

    context 'on a sub-schema' do
      let(:schema){
        Module.new{
          include Alf::Schema
          def hello
            "world"
          end
        }
      }

      it 'uses the expected binding' do
        schema.parse{ hello }.should eq("world")
      end
    end

  end
end
