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

        context "with Lispy" do 
          let(:operator){ Lispy.autonum(input) }
          it{ should == expected }
        end

      end # default attribute name

      context "with explicit attribute name" do
        let(:expected){[
          {:a => "a", :unique => 0},
          {:a => "b", :unique => 1},
          {:a => "a", :unique => 2},
        ]}

        context "with Lispy" do 
          let(:operator){ Lispy.autonum(input, :unique) }
          it{ should == expected }
        end

      end # explicit attribute name

    end
  end
end
