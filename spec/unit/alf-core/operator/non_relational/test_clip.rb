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

      context "--no-allbut" do
        let(:expected){[{:a => "a"}]}

        context "with Lispy" do
          let(:operator){ Lispy.clip(input, [:a]) }
          it { should == expected } 
        end

        context "with .run" do
          let(:operator){ Clip.run([input] + %w{-- a}) }
          it { should == expected } 
        end
      end # --no-allbut

      context "--allbut" do
        let(:expected){[{:b => "b"}]}

        context "with Lispy" do
          let(:operator){ Lispy.clip(input, [:a], :allbut => true) }
          it { should == expected } 
        end

        context "with .run" do
          let(:operator){ Clip.run([input] + %w{--allbut -- a}) }
          it { should == expected } 
        end
      end # --allbut
  
    end 
  end
end
