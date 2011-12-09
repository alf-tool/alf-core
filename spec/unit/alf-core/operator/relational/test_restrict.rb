require 'spec_helper'
module Alf
  module Operator::Relational
    describe Restrict do

      let(:operator_class){ Restrict }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:tested => 1, :other => "b"},
        {:tested => 30, :other => "a"},
      ]}

      let(:expected){[
        {:tested => 1, :other => "b"}
      ]}

      subject{ operator.to_a }

      context "with no argument" do
        let(:operator){ Restrict.run([input]) }
        it { should eq(input) }
      end

      context "with a string" do
        context "with .run" do
          let(:operator){ Restrict.run([input, "--", "tested < 10"]) }
          it { should eq(expected) }
        end
        context "with Lispy" do
          let(:operator){ Lispy.restrict(input, "tested < 10") }
          it { should eq(expected) }
        end
      end

      context "with arguments" do
        context "with .run" do
          let(:operator){ Restrict.run([input, "--", "tested", "1"]) }
          it { should eq(expected) }
        end
        context "with Lispy and Proc" do
          let(:operator){ Lispy.restrict(input, lambda{ tested < 10 }) }
          it { should eq(expected) }
        end
        context "with Lispy and array" do
          let(:operator){ Lispy.restrict(input, [:tested, 1]) }
          it { should eq(expected) }
        end
      end

    end 
  end
end
