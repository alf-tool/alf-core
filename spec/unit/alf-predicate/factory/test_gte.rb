require_relative "shared/a_comparison_factory_method"
module Alf
  class Predicate
    describe Factory, 'gte' do
      let(:method){ :gte }
      let(:node_class){ Gte }

      it_should_behave_like "a comparison factory method"
    end
  end
end
