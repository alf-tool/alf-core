module Alf
  class Optimizer
    shared_examples_for "a split-able expression for restrict" do

      let(:split_pred){
        Predicate.eq(split_attributes.to_a.first, 12)
      }
      let(:stay_pred){
        Predicate.eq(:a_non_split_attribute, 12)
      }

      context 'with a native predicate' do
        let(:predicate){ Predicate.native(lambda{ true }) }

        it_should_behave_like "an unoptimizable expression for restrict"
      end

      context 'with no split attributes' do
        let(:predicate){ stay_pred }

        it_should_behave_like "a pass-through expression for restrict"
      end

      context 'with only split attributes' do
        let(:predicate){ split_pred }

        it_should_behave_like "an unoptimizable expression for restrict"
      end

      context 'with split and non-split in a OR' do
        let(:predicate){ split_pred | stay_pred }

        it_should_behave_like "an unoptimizable expression for restrict"
      end

      context 'with split and non-split in a COMP' do
        let(:predicate){ split_pred & stay_pred }

        it_should_behave_like "an optimizable expression for restrict"
      end

      context 'with split and non-split in the same EXPR' do
        let(:predicate){ Predicate.eq(split_attributes.to_a.first, :a_non_split_attribute) }

        it_should_behave_like "an unoptimizable expression for restrict"
      end

    end
  end
end