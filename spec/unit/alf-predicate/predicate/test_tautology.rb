require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "tautology?" do

      subject{ pred.tautology? }

      context "tautology" do
        subject{ Predicate.tautology }

        it{ should be_true }
      end

      context "contradiction" do
        subject{ Predicate.contradiction }

        it{ should be_false }
      end

      context "var_ref" do
        subject{ Predicate.var_ref(:x) }

        it{ should be_false }
      end

    end
  end
end