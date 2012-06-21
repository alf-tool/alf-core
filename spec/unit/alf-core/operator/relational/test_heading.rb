require 'spec_helper'
module Alf
  module Operator::Relational
    describe Heading do

      let(:operator_class){ Heading }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:tested => 1,    :other => "b"},
        {:tested => 10.0, :other => "a"},
      ]}

      let(:expected){[
        {:tested => Numeric, :other => String},
      ]}

      subject{ operator.to_a }

      context "with Lispy" do 
        let(:operator){ a_lispy.heading(input) }
        it{ should == expected }
      end

    end 
  end
end
