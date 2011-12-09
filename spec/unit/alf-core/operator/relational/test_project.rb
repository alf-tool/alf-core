require 'spec_helper'
module Alf
  module Operator::Relational
    describe Project do

      let(:operator_class){ Project }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:a => "a", :b => "b"},
        {:a => "a", :b => "b"},
      ]}

      subject{ operator.to_a }

      context "--no-allbut" do
        let(:expected){[{:a => "a"}]}

        context "with .run" do
          let(:operator){ Project.run([input, "--", 'a']) }
          it { should eq(expected) } 
        end

        context "with Lispy" do
          let(:operator){ Lispy.project(input, [:a]) }
          it { should eq(expected) } 
        end
      end # --no-allbut

      context "--allbut" do
        let(:expected){[{:b => "b"}]}

        context "and factored with commandline args" do
          let(:operator){ Project.run([input, '--allbut', '--', 'a']) }
          it { should eq(expected) } 
        end

        context "and factored with Lispy#project" do
          let(:operator){ Lispy.project(input, [:a], :allbut => true) }
          it { should eq(expected) } 
        end

        context "and factored with Lispy#allbut" do
          let(:operator){ Lispy.allbut(input, [:a]) }
          it { should eq(expected) } 
        end

      end # --allbut

      context "when all is projected" do
        let(:expected){[{}]}

        context "with empty attributes" do
          let(:operator){ Lispy.project(input, []) }
          it { should eq(expected) } 
        end

        context "when empty attributes and input" do
          let(:operator){ Lispy.project([], []) }
          it { should == [] } 
        end

        context "--allbut" do
          let(:operator){ Lispy.project(input, [:a, :b], :allbut => true) }
          it { should eq(expected) } 
        end

      end # all attributes projected

    end 
  end
end
