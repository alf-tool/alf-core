require File.expand_path('../spec_helper', __FILE__)
module Alf
  describe Restrict do
      
    let(:input) {[
      {:tested => 1, :other => "b"},
      {:tested => 30, :other => "a"},
    ]}

    let(:expected){[
      {:tested => 1, :other => "b"}
    ]}

    subject{ operator.to_a }

    describe "when used with no argument" do
      let(:operator){ Restrict.new.set_args([]) }
      before{ operator.pipe(input) }
      it { should == input }
    end

    describe "when used with a string" do
      describe "when factored with commandline args" do
        let(:operator){ Restrict.run(["--", "tested < 10"]) }
        before{ operator.pipe(input) }
        it { should == expected }
      end
      describe "when factored with Lispy" do
        let(:operator){ Lispy.restrict(input, "tested < 10") }
        it { should == expected }
      end
    end

    describe "when used with arguments" do
      describe "when factored with commandline args" do
        let(:operator){ Restrict.run(["--", "tested", "1"]) }
        before{ operator.pipe(input) }
        it { should == expected }
      end
      describe "when factored with Lispy and Proc" do
        let(:operator){ Lispy.restrict(input, lambda{ tested < 10 }) }
        it { should == expected }
      end
      describe "when factored with Lispy and array" do
        let(:operator){ Lispy.restrict(input, [:tested, 1]) }
        it { should == expected }
      end
    end

  end 
end
