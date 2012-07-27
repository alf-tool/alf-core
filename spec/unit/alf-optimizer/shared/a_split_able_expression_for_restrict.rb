module Alf
  class Optimizer
    shared_examples_for "a split-able expression for restrict" do

      let(:split_pred){
        Predicate.comp(:eq, Hash[split_attributes.attributes.map{|k| [k, 12] }])
      }
      let(:stay_pred){
        Predicate.comp(:eq, :a_non_split_attribute => 12)
      }

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

    end
  end
end