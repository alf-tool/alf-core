require 'spec_helper'
module Alf
  module Algebra
    describe Quota do

      let(:operator_class){ Quota }

      it_should_behave_like("An operator class")

      let(:aggs){{:time_sum => Aggregator.sum{ time },
                  :time_max => Aggregator.max{ time }}}

      subject{ a_lispy.quota([], [:a], [:time], aggs) }

      it { should be_a(Quota) }

    end
  end
end
