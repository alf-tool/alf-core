require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Autonum do

      let(:operator_class){ Autonum }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:a => "a"},
        {:a => "b"},
        {:a => "a"},
      ]}

      subject{ operator.to_a }

      context "with default attribute name" do

        let(:expected){[
          {:a => "a", :autonum => 0},
          {:a => "b", :autonum => 1},
          {:a => "a", :autonum => 2},
        ]}

        describe "When factored with Lispy" do 
          let(:operator){ Lispy.autonum(input) }
          it{ should == expected }
        end

        describe "When factored from commandline args" do
          let(:operator){ Autonum.run([input]) }
          it{ should == expected }
        end

      end

      context "when providing an attribute name" do

        let(:expected){[
          {:a => "a", :unique => 0},
          {:a => "b", :unique => 1},
          {:a => "a", :unique => 2},
        ]}

        describe "When factored with Lispy" do 
          let(:operator){ Lispy.autonum(input, :unique) }
          it{ should == expected }
        end

        describe "When factored from commandline args" do
          let(:operator){ Autonum.run([input, "--", "unique"]) }
          it{ should == expected }
        end

      end

    end
  end
end
