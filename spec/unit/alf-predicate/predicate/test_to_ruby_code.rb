require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "to_ruby_code" do

      subject{ p.to_ruby_code }

      describe "on a comp(:eq)" do
        let(:p){ Predicate.coerce(:x => 2) }

        it{ should eq("->(t){ t.x == 2 }") }
      end

      describe "with qualified identifiers" do
        let(:p){ Predicate.eq(Factory.qualified_identifier(:t, :y), 2) }

        it{ should eq("->(t){ t.y == 2 }") }
      end

    end
  end
end