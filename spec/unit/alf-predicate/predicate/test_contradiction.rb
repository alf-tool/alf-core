require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "contradiction?" do

      subject{ pred.contradiction? }

      context "tautology" do
        subject{ Predicate.tautology }

        it{ should be_false }
      end

      context "contradiction" do
        subject{ Predicate.contradiction }

        it{ should be_true }
      end

      context "identifier" do
        subject{ Predicate.identifier(:x) }

        it{ should be_false }
      end

    end
  end
end