require 'spec_helper'
module Alf
  describe Tuple, "split" do 

    let(:tuple){ Tuple(a: 1, b: 2, c: 3) }

    subject{ tuple.split(list) }

    context 'with the whole list' do
      let(:list){ [:a, :b, :c] }

      it{ should eq([ tuple, Tuple::EMPTY ]) }
    end

    context 'with a sublist' do
      let(:list){ [:a, :c] }

      it{ should eq([ Tuple(a: 1, c: 3), Tuple(b: 2) ]) }
    end

    context 'with an empty list' do
      let(:list){ [] }

      it{ should eq([ Tuple::EMPTY, tuple ]) }
    end

  end
end
