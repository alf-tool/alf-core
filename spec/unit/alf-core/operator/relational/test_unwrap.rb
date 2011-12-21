require 'spec_helper'
module Alf
  module Operator::Relational
    describe Unwrap do

      let(:operator_class){ Unwrap }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:wrapped => {:a => "a", :b => "b"}, :c => "c"}
      ]}

      let(:expected) {[
        {:a => "a", :b => "b", :c => "c"},
      ]}

      subject{ operator.to_a }

      context "when factored with Lispy" do
        let(:operator){ Lispy.unwrap(input, :wrapped) }
        it { should eq(expected) }
      end

    end
  end
end
