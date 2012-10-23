require 'spec_helper'
module Alf
  module Lang
    describe "Relation(...) literal" do
      include Functional

      describe 'on a single tuple' do
        subject{ Relation(name: "Jones") }

        it{ should eq(Alf::Relation.coerce([{name: "Jones"}])) }
      end

      describe 'on an array of tuples' do
        subject{ Relation([{name: "Jones"}, {name: "Smith"}])}

        it{ should eq(Alf::Relation.coerce([{name: "Jones"}, {name: "Smith"}])) }
      end

    end
  end
end
