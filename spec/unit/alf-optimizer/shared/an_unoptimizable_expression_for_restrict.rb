module Alf
  class Optimizer
    shared_examples_for "an unoptimizable expression for restrict" do

      let(:the_predicate){
        defined?(predicate) ? predicate : Predicate.eq(:x, 12)
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

      specify "optimized is unchanged" do
        optimized.should eq(restriction)
      end

    end
  end
end