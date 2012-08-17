require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "evaluate" do

      let(:predicate){ 
        Predicate.new(Factory.lte(:x => 2))
      }

      subject{ predicate.evaluate(scope) }

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