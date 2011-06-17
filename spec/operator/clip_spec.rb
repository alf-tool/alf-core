require 'spec_helper'
module Alf
  describe Clip do
      
    let(:input) {[
      {:a => "a", :b => "b"},
    ]}

    subject{ operator.to_a }

    describe "When used without --allbut" do
      let(:expected){[{:a => "a"}]}

      describe "when factored from commandline" do
        let(:operator){ Clip.run(%w{-- a}) }
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
        let(:operator){ Clip.run(%w{--allbut -- a}) }
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
