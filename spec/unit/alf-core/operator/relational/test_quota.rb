require 'spec_helper'
module Alf
  module Operator::Relational
    describe Quota do

      let(:operator_class){ Quota }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:a => "via_method", :time => 1},
        {:a => "via_method", :time => 2},
        {:a => "via_method", :time => 3},
        {:a => "via_reader", :time => 4},
        {:a => "via_reader", :time => 2},
      ]}

      let(:expected) {[
        {:a => "via_method", :time => 1, :time_sum => 1, :time_max => 1},
        {:a => "via_method", :time => 2, :time_sum => 3, :time_max => 2},
        {:a => "via_method", :time => 3, :time_sum => 6, :time_max => 3},
        {:a => "via_reader", :time => 2, :time_sum => 2, :time_max => 2},
        {:a => "via_reader", :time => 4, :time_sum => 6, :time_max => 4},
      ]}

      subject{ operator.to_a }

      context "with Lispy" do
        let(:aggs){{:time_sum => Aggregator.sum{ time },
                    :time_max => Aggregator.max{ time }}} 
        let(:operator){ a_lispy.quota(input, [:a], [:time], aggs) }
        it { should == expected }
      end

    end
  end
end
