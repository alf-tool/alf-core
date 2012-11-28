require 'spec_helper'
module Alf
  describe Relvar, 'empty!' do
    include Relvar

    subject{ empty! }

    context 'on an empty relvar' do
      let(:to_cog){ [] }

      it{ should be(self) }
    end

    context 'on an non empty relvar' do
      let(:to_cog){ [ 1 ] }

      it "should raise a fact error" do
        lambda{ subject }.should raise_error(Alf::FactAssertionError)
      end
    end

    context 'on an non empty relvar with an error message' do
      let(:to_cog){ [ 1 ] }

      it "should raise a fact error" do
        lambda{ empty!("foo") }.should raise_error(Alf::FactAssertionError, /foo/)
      end
    end

  end
end
