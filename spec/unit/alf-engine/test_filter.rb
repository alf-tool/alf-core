require 'spec_helper'
module Alf
  module Engine
    describe Filter do

      subject{ Filter.new(operand, predicate).to_a }

      context 'on an empty operand' do
        let(:operand)  { Leaf.new([])           }
        let(:predicate){ Predicate.coerce(true) }

        it{ should eq([]) }
      end

      context 'on a non-empty operand' do
        let(:operand){
          Leaf.new [
            {:name => "Jones"},
            {:name => "Smith"}
          ]
        }
        let(:predicate){
          Predicate.native(->(t){ t.name =~ /^J/ })
        }
        let(:expected){
          [
            {:name => "Jones"},
          ]
        }

        it{ should eq(expected) }
      end

      context 'on a predicate of arity 1' do
        let(:operand){
          Leaf.new [
            {:name => "Jones"},
            {:name => "Smith"}
          ]
        }
        let(:predicate){
          Predicate.native(->(t){ t[:name] =~ /^J/})
        }
        let(:expected){
          [
            {:name => "Jones"},
          ]
        }

        it{ should eq(expected) }
      end

    end
  end # module Engine
end # module Alf
