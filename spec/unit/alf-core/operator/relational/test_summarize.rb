require 'spec_helper'
module Alf
  module Operator::Relational
    describe Summarize do

      let(:operator_class){ Summarize }

      it_should_behave_like("An operator class")

      let(:aggs){{:time_sum => Aggregator.sum{ time },
                  :time_max => Aggregator.max{ time },
                  :time_avg => Aggregator.avg{ time }}}

      context "--no-allbut" do
        subject{ a_lispy.summarize([], [:a], aggs) }

        it { should be_a(Summarize) }

        it 'is !allbut by default' do
          subject.allbut.should be_false
        end
      end # --no-allbut

      context "--allbut" do
        subject{ a_lispy.summarize([], [:time], aggs, :allbut => true) }

        it { should be_a(Summarize) }

        it 'is allbut' do
          subject.allbut.should be_true
        end
      end # --allbut

    end
  end
end
