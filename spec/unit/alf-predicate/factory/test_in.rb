require_relative "shared/a_comparison_factory_method"
module Alf
  class Predicate
    describe Factory, 'in' do

      subject{ Factory.in(:x, [2, 3]) }

      it{ should be_a(In) }

      it{ should eq([:in, [:var_ref, :x], [2, 3]]) }

    end
  end
end
