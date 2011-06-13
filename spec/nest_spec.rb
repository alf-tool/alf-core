require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Nest do
      
    let(:input) {[
      {:a => "a", :b => "b", :c => "c"},
    ]}

    let(:expected) {[
      {:nested => {:a => "a", :b => "b"}, :c => "c"}
    ]}

    subject{ operator.to_a }

    describe "when factored with commandline args" do
      let(:operator){ Nest.new.set_args(["a", "b", "nested"]) }
      before{ operator.input = input }
      it { should == expected }
    end

    describe "when factored with Lispy" do
      let(:operator){ Lispy.nest(input, [:a, :b], :nested) }
      it { should == expected }
    end

  end 
end
