require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "and_split" do

      let(:p){ Predicate }
      subject{ pred.and_split(AttrList[:x]) }

      context "on tautology" do
        let(:pred){ p.tautology }

        it{ should eq([p.tautology, p.tautology]) }
      end

      context "on contradiction" do
        let(:pred){ p.contradiction }

        it{ should eq([p.tautology, pred]) }
      end

      context "on identifier (included)" do
        let(:pred){ p.identifier(:x) }

        it{ should eq([ pred, p.tautology ]) }
      end

      context "on identifier (excluded)" do
        let(:pred){ p.identifier(:y) }

        it{ should eq([ p.tautology, pred ]) }
      end

      context "on not (included)" do
        let(:pred){ p.not(:x) }

        it{ should eq([ pred, p.tautology ]) }
      end

      context "on not (excluded)" do
        let(:pred){ p.not(:y) }

        it{ should eq([ p.tautology, pred ]) }
      end

      context "on eq (included)" do
        let(:pred){ p.eq(:x, 2) }

        it{ should eq([ pred, p.tautology ]) }
      end

      context "on eq (excluded)" do
        let(:pred){ p.eq(:y, 2) }

        it{ should eq([ p.tautology, pred ]) }
      end

    end
  end
end