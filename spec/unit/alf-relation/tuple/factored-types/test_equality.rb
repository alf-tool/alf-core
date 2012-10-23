require 'spec_helper'
module Alf
  describe Tuple, '.==' do

    let(:tuple_type){ Tuple[name: String, status: Integer] }

    subject{ tuple_type == other }

    context 'with itself' do
      let(:other){ tuple_type }

      it{ should be_true }
    end

    context 'with another equivalent' do
      let(:other){ Tuple[name: String, status: Integer] }

      it{ should be_true }
    end

    context 'with another, non equivalent' do
      let(:other){ Tuple[name: String] }

      it{ should be_false }
    end

  end
end
