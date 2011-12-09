require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Clip do

      let(:operator_class){ Clip }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:a => "a", :b => "b"},
      ]}

      subject{ operator.to_a }

      describe "When used without --allbut" do
        let(:expected){[{:a => "a"}]}

        describe "when factored with Lispy" do
          let(:operator){ Lispy.clip(input, [:a]) }
          it { should == expected } 
        end

        describe "when factored from commandline" do
          let(:operator){ Clip.run([input] + %w{-- a}) }
          it { should == expected } 
        end
      end # --no-allbut

      describe "When used with --allbut" do
        let(:expected){[{:b => "b"}]}

        describe "when factored with Lispy" do
          let(:operator){ Lispy.clip(input, [:a], :allbut => true) }
          it { should == expected } 
        end

        describe "when factored with commandline args" do
          let(:operator){ Clip.run([input] + %w{--allbut -- a}) }
          it { should == expected } 
        end
      end # --allbut
  
    end 
  end
end
