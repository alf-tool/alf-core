require 'spec_helper'
module Alf
  describe Nest do
      
    let(:operator_class){ Nest }
    it_should_behave_like("An operator class")
      
    let(:input) {[
      {:a => "a", :b => "b", :c => "c"},
    ]}

    let(:expected) {[
      {:nested => {:a => "a", :b => "b"}, :c => "c"}
    ]}

    subject{ operator.to_a }

    describe "when factored with commandline args" do
      let(:operator){ Nest.run(["--", "a", "b", "nested"]) }
      before{ operator.pipe(input) }
      it { should == expected }
    end

    describe "when factored with Lispy" do
      let(:operator){ Lispy.nest(input, [:a, :b], :nested) }
      it { should == expected }
    end

  end 
end
