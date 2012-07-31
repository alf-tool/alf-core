module Alf
  class Optimizer
    shared_examples_for "a pass-through expression for restrict" do

      let(:the_predicate){
        defined?(predicate) ? predicate : Predicate.native(lambda{})
      }

      let(:restriction){
        restrict(subject, the_predicate)
      }

      let(:optimized){
        Restrict.new.call(restriction)
      }

      # before(:all) do
      #   puts Tools.to_lispy(restriction)
      #   puts Tools.to_lispy(optimized)
      # end

      specify "optimized leads to the initial operator" do
        optimized.should be_a(subject.class)
      end

      specify "optimized signature is unchanged" do
        optimized.signature.collect_on(subject).should eq(subject.signature.collect_on(subject))
      end

      specify "the restriction has been pushed with same predicate" do
        optimized.operands.each do |operand|
          operand.should be_a(Operator::Relational::Restrict)
          repl = defined?(replaced_predicate) ? replaced_predicate : restriction.predicate
          operand.predicate.should eq(repl)
        end
      end

    end
  end
end