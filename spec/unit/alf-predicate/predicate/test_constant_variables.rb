require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "constant_variables" do

      subject{ p.constant_variables }

      describe "on a comp(:eq)" do
        let(:p){ Predicate.coerce(x: 2, y: 3) }

        it{ should eq(AttrList[:x, :y]) }
      end

      describe "on a in with one value" do
        let(:p){ Predicate.in(:x, [2]) }

        it{ should eq(AttrList[:x]) }
      end

      describe "on a in with mutiple values" do
        let(:p){ Predicate.in(:x, [2, 3]) }

        it{ should eq(AttrList::EMPTY) }
      end

      describe "on a NOT" do
        let(:p){ !Predicate.coerce(x: 2) }

        it{ should eq(AttrList::EMPTY) }
      end

      describe "on a AND" do
        let(:p){ Predicate.coerce(x: 2) & Predicate.coerce(y: 3) }

        it{ should eq(AttrList[:x, :y]) }
      end

      describe "on a OR" do
        let(:p){ Predicate.coerce(x: 2) | Predicate.coerce(y: 3) }

        it{ should eq(AttrList::EMPTY) }
      end

      describe "on a negated OR" do
        let(:p){ !(Predicate.coerce(x: 2) | Predicate.coerce(y: 3)) }

        pending("NNF would make constant_variables smarter"){
          it{ should eq(AttrList[:x, :y]) }
        }
      end

    end
  end
end