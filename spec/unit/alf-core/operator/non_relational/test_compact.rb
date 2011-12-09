require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Compact do

      let(:operator_class){ Compact }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:a => "via_method", :time => 1, :b => "b"},
        {:a => "via_reader", :time => 3, :b => "b"},
        {:a => "via_method", :time => 2, :b => "b"},
        {:a => "via_reader", :time => 3, :b => "b"},
        {:a => "via_method", :time => 1, :b => "b"},
      ]}

      let(:expected) {[
        {:a => "via_method", :time => 1, :b => "b"},
        {:a => "via_reader", :time => 3, :b => "b"},
        {:a => "via_method", :time => 2, :b => "b"},
      ]}

      subject{ operator.to_a }

      context "with Lispy" do
        let(:operator){ Lispy.compact(input) }
        it { should == expected }
      end

      context "with .run" do
        let(:operator){ Compact.run([input]) }
        it { should == expected }
      end

    end
  end
end
