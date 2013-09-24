require_relative "shared/a_comparison_factory_method"
module Alf
  class Predicate
    describe Factory, 'between' do

      subject{ Factory.between(:x, 2, 3) }

      it{ should be_a(And) }

      it{ should eq([:and, [:gte, [:identifier, :x], [:literal, 2]], [:lte, [:identifier, :x], [:literal, 3]]]) }

    end
  end
end
