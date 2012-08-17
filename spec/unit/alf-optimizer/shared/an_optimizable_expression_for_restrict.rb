module Alf
  class Optimizer
    shared_examples_for "an optimizable expression for restrict" do

      let(:restriction){
        restrict(subject, predicate)
      }

      let(:optimized){
        Restrict.new.call(restriction)
      }

      let(:middle){
        optimized.operand
      }

      let(:inside){
        middle.operand
      }

      # before(:all) do
      #   puts "\n--------"
      #   puts Support.to_lispy(restriction)
      #   puts Support.to_lispy(optimized)
      # end

      specify "optimized leads to a restrict[initial[restrict[...]]]" do
        optimized.should be_a(Operator::Relational::Restrict)
        middle.should be_a(subject.class)
        inside.should be_a(Operator::Relational::Restrict)
      end

      specify "middle's signature is kept unchanged" do
        middle.signature.collect_on(subject).should eq(subject.signature.collect_on(subject))
      end

      specify "first restriction only applies on split attributes" do
        optimized.predicate.free_variables.should eq(split_attributes)
      end

    end
  end
end