require_relative "shared/a_comparison_factory_method"
module Alf
  module Predicate
    describe Factory, 'neq' do
      let(:method){ :neq }
      let(:node_class){ Neq }

      it_should_behave_like "a comparison factory method"
    end
  end
end
