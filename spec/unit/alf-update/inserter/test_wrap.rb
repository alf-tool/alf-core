require 'update_helper'
module Alf
  module Update
    describe Inserter, 'wrap' do

      let(:expr)     { wrap(suppliers, [:foo], :bar) }
      let(:inserted) { [
        {:name => "Jones", :bar => {:foo => 12} },
        {:name => "Smith", :bar => {:foo => 15} }
      ] }
      let(:expected) { [
        {:name => "Jones", :foo => 12},
        {:name => "Smith", :foo => 15}
      ] }

      subject{ insert(expr, inserted) }

      it 'requests the insertion of the tuples on :suppliers' do
        subject
        context.requests.should eq([ [:insert, :suppliers, expected] ])
      end

    end
  end
end