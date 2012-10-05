require 'spec_helper'
module Alf
  describe Relvar, 'not_empty!' do
    include Relvar

    subject{ not_empty! }

    context 'on an empty relvar' do
      let(:to_cog){ [] }

      it "should raise a fact error" do
        lambda{ subject }.should raise_error(Alf::FactAssertionError)
      end
    end

    context 'on an non empty relvar' do
      let(:to_cog){ [ 1 ] }

      it{ should be_true }
    end

  end
end
