require File.expand_path('../spec_helper', __FILE__)
module Alf
  describe Clip do
      
    let(:input) {[
      {:a => "a", :b => "b"},
    ]}

    subject{ operator.to_a }

    describe "When used without --allbut" do
      let(:expected){[{:a => "a"}]}

      describe "when factored with commandline args" do
        let(:operator){ Clip.new.set_args(['a']) }
        before{ operator.pipe(input) }
        it { should == expected } 
      end

      describe "when factored with Lispy" do
        let(:operator){ Lispy.clip(input, [:a]) }
        it { should == expected } 
      end

    end

    describe "When used with --allbut" do
      let(:expected){[{:b => "b"}]}

      describe "when factored with commandline args" do
        let(:operator){ Clip.new([], true).set_args(['a']) }
        before{ operator.pipe(input) }
        it { should == expected } 
      end

      describe "when factored with Lispy" do
        let(:operator){ Lispy.clip(input, [:a], true) }
        it { should == expected } 
      end

    end

  end 
end
