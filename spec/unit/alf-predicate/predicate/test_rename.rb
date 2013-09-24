require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "rename" do

      let(:p){ Predicate }

      subject{ predicate.rename(renaming) }
      let(:renaming) { Renaming[:x => :z] }

      context 'on a full AST predicate' do
        let(:predicate){ p.in(:x, [2]) & p.eq(:y, 3) }

        it{ should eq(p.in(:z, [2]) & p.eq(:y, 3)) }

        specify "it should tag expressions correctly" do
          subject.expr.should be_a(Sexpr)
          subject.expr.should be_a(Expr)
          subject.expr.should be_a(And)
        end
      end

      context 'on a predicate that contains natives' do
        let(:predicate){ p.in(:x, [2]) & p.native(lambda{}) }

        it 'raises an error' do
          lambda{
            subject
          }.should raise_error(NotSupportedError)
        end
      end

      context 'on a predicate that contains qualified identifiers' do
        let(:predicate){ p.eq(Factory.qualified_identifier(:t, :x), 3) }

        it 'renames correctly' do
          subject.should eq(p.eq(Factory.qualified_identifier(:t, :z), 3))
        end
      end

    end
  end
end