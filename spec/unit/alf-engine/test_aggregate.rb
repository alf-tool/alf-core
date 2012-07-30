require 'spec_helper'
module Alf
  module Engine
    describe Aggregate do

      it 'should work on an empty operand' do
        Autonum.new(Leaf.new([]), Summarization[{}]).to_a.should eq([])
      end

      it 'should work on a non empty operand' do
        rel = Leaf.new [
          {:name => "Jones", :price => 12.0, :id => 1},
          {:name => "Smith", :price => 10.0, :id => 2}
        ]
        agg = Summarization[:size  => "count", 
                            :total => "sum{ price }"]
        exp = [
          {:size => 2, :total => 22.0}
        ]
        Aggregate.new(rel, agg).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf    

