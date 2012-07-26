require_relative "shared/a_comparison_factory_method"
module Alf
  class Predicate
    describe Factory, 'gt' do
      let(:method){ :gt }
      let(:node_class){ Gt }

      it_should_behave_like "a comparison factory method"
    end
  end
end
