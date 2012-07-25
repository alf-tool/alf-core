require 'spec_helper'
module Alf
  describe AttrList, 'superset?' do

    context 'when equal' do
      let(:left){ AttrList[:id, :name] }
      let(:right){ AttrList[:name, :id] }

      it 'returns true if non proper' do
        left.superset?(right).should be_true
      end
      it 'returns false if proper' do
        left.superset?(right, true).should be_false
      end
    end

    context 'when both empty' do
      let(:left){ AttrList[] }
      let(:right){ AttrList[] }

      it 'returns true if non proper' do
        left.superset?(right).should be_true
      end
      it 'returns false if proper' do
        left.superset?(right, true).should be_false
      end
    end

    context 'when disjoint' do
      let(:left){ AttrList[:status] }
      let(:right){ AttrList[:name, :id] }

      it 'returns false' do
        left.superset?(right).should be_false
        left.superset?(right, true).should be_false
      end
    end

    context 'when a proper supserset' do
      let(:left){ AttrList[:id, :name] }
      let(:right){ AttrList[:name] }

      it 'returns true' do
        left.superset?(right).should be_true
        left.superset?(right, true).should be_true
      end
    end

  end
end