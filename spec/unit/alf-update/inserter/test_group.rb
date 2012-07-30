require 'update_helper'
module Alf
  module Update
    describe Inserter, 'group' do

      let(:expr)     { group(suppliers, [:foo], :bar) }
      let(:inserted) { [
        {:name => "Jones", :bar => Relation(:foo => [12, 13]) },
        {:name => "Smith", :bar => Relation(:foo => [15])     }
      ] }
      let(:expected) { [
        {:name => "Jones", :foo => 12},
        {:name => "Jones", :foo => 13},
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