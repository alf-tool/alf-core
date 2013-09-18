require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "evaluate" do

      subject{ predicate.evaluate(scope) }

      context 'on a native predicate of arity 1' do
        let(:predicate){
          Predicate.native(->(t){ t[:name] =~ /foo/ })
        }

        context 'on a matching tuple' do
          let(:scope){ {name: "foo"} }

          it{ should be_true }
        end

        context 'on a non-matching tuple' do
          let(:scope){ {name: "bar"} }

          it{ should be_false }
        end
      end

      context 'on a factored predicate' do
        let(:predicate){
          Predicate.new(Factory.lte(:x => 2))
        }

        describe "on x == 2" do
          let(:scope){ Support::TupleScope.new(:x => 2) }

          it{ should be_true }
        end

        describe "on x == 1" do
          let(:scope){ Support::TupleScope.new(:x => 1) }

          it{ should be_true }
        end

        describe "on x == 3" do
          let(:scope){ Support::TupleScope.new(:x => 3) }

          it{ should be_false }
        end
      end

    end
  end
end