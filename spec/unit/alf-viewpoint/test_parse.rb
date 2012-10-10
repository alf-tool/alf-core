require 'spec_helper'
module Alf
  describe Viewpoint, "parse" do

    it 'allows parsing predicate expressions' do
      Viewpoint.parse{
        tautology
      }.should eq(Predicate.tautology)
      Viewpoint.parse{
        eq(:x, 2)
      }.should be_a(Predicate)
    end

    it 'allows parsing relational expressions' do
      Viewpoint.parse{
        restrict(:suppliers, ->{ sid == 'S1' })
      }.should be_a(Algebra::Restrict)
    end

    context 'on a sub-viewpoint' do
      let(:viewpoint){
        Module.new{
          include Alf::Viewpoint
          def hello
            "world"
          end
        }
      }

      it 'uses the expected binding' do
        viewpoint.parse{ hello }.should eq("world")
      end
    end

  end
end
