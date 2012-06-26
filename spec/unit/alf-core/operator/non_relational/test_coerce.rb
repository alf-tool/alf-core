require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Coerce do

      let(:operator_class){ Coerce }
      it_should_behave_like("An operator class")

      let(:input) {Alf::Relation[
        {:a => "12", :b => "14.0"},
      ]}

      subject{ operator.to_relation }

      context "--no-strict" do
        let(:expected){Alf::Relation[
          {:a => 12, :b => 14.0}
        ]}

        context "with Lispy" do
          let(:operator){ a_lispy.coerce(input, :a => Integer, :b => Float) }
          it { should == expected }
        end

      end # --no-strict

    end
  end
end
