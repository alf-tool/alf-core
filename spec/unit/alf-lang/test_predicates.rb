require 'spec_helper'
module Alf
  module Lang
    describe Predicates do
      include Predicates

      it "eq should factor a predicate" do
        eq(:x, 12).should be_a(Alf::Predicate)
      end

      it "between should factor a predicate" do
        between(:x, 2, 3).should be_a(Alf::Predicate)
      end

    end
  end
end