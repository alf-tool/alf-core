shared_examples_for "an unoptimizable expression for restrict" do

  let(:the_predicate){
    defined?(predicate) ? predicate : Alf::Predicate.eq(:x, 12)
  }

  let(:restriction){
    restrict(subject, the_predicate)
  }

  let(:optimized){
    Alf::Optimizer::Restrict.new.call(restriction)
  }

  # before(:all) do
  #   puts Support.to_lispy(restriction)
  #   puts Support.to_lispy(optimized)
  # end

  specify "optimized is unchanged" do
    optimized.should eq(restriction)
  end

end
