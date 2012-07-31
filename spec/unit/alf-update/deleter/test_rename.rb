require 'update_helper'
module Alf
  module Update
    describe Deleter, 'rename' do

      let(:expr){ rename(suppliers, :city => :location) }

      subject{ delete(expr, predicate) }

      context 'pass-through' do
        let(:predicate){ Predicate.eq(:id => 1) }

        it 'requests the deletion on :suppliers' do
          subject
          db_context.requests.should eq([ [:delete, :suppliers, predicate] ])
        end
      end

      context 'non pass-through' do
        let(:predicate){ Predicate.eq(:location => "London") }

        it 'requests the deletion on :suppliers' do
          pending "need for Predicate#rename" do
            subject
          end
        end
      end

    end
  end
end