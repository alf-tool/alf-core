require 'spec_helper'
module Alf
  module Operator::Relational
    describe Extend do

      let(:operator_class){ Extend }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:tested => 1,  :other => "b"},
        {:tested => 30, :other => "a"},
      ]}

      let(:expected){[
        {:tested => 1,  :other => "b", :big => false},
        {:tested => 30, :other => "a", :big => true},
      ]}

      subject{ operator.to_a }

      context "with Lispy" do 
        let(:operator){ Lispy.extend(input, :big => lambda{ tested > 10 }) }
        it{ should == expected }
      end

      context "with .run" do
        let(:operator){ Extend.run([input] + %w{-- big} + ["tested > 10"]) }
        it{ should == expected }
      end

    end 
  end
end
