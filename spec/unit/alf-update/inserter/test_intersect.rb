require 'update_helper'
module Alf
  module Update
    describe Inserter, 'intersect' do

      let(:expr)     { intersect(suppliers, parts) }
      let(:inserted) { [ {:name => "Jones"}, {:name => "Smith"} ] }
      let(:expected) { [ {:name => "Jones"}, {:name => "Smith"} ] }

      subject{ insert(expr, inserted) }

      it 'requests the insertion of the tuples on :suppliers' do
        subject
        context.requests.should eq([
          [:insert, :suppliers, expected],
          [:insert, :parts, expected],
        ])
      end

    end
  end
end