require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Unnest do
      
    let(:input) {[
      {:nested => {:a => "a", :b => "b"}, :c => "c"}
    ]}

    let(:expected) {[
      {:a => "a", :b => "b", :c => "c"},
    ]}

    subject{ operator.to_a }

    describe "when factored with commandline args" do
      let(:operator){ Unnest.new.set_args(["nested"]).pipe(input) }
      it { should == expected }
    end

    describe "when factored with Lispy" do
      let(:operator){ Lispy.unnest(input, :nested) }
      it { should == expected }
    end

  end 
end
