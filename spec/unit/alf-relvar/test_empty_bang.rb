require 'spec_helper'
module Alf
  describe Relvar, 'empty!' do

    subject{ relvar.empty! }

    context 'on an empty relvar' do
      let(:relvar){
        examples_database.relvar{ restrict(suppliers, false) }
      }

      it{ should be_true }
    end

    context 'on an non empty relvar' do
      let(:relvar){
        examples_database.relvar(:suppliers)
      }

      it "should raise a fact error" do
        lambda{ subject }.should raise_error(Alf::FactAssertionError)
      end
    end

  end
end