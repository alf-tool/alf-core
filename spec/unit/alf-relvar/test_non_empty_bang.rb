require 'spec_helper'
module Alf
  describe Relvar, 'not_empty!' do

    subject{ relvar.not_empty! }

    context 'on an empty relvar' do
      let(:relvar){
        examples_database.relvar{ restrict(suppliers, false) }
      }

      it "should raise a fact error" do
        lambda{ subject }.should raise_error(Alf::FactAssertionError)
      end
    end

    context 'on an non empty relvar' do
      let(:relvar){
        examples_database.relvar(:suppliers)
      }

      it{ should be_true }
    end

  end
end