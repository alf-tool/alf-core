require 'spec_helper'
module Alf
  describe Relation, '[]' do

    let(:rel){ Alf::Relation(sid: 'S1', sname: "Jones", city: "London") }

    context 'as a selection' do
      subject{ rel[:pid => :sid] }

      let(:expected){ Alf::Relation(pid: 'S1') }

      it{ should eq(expected) }
    end

    context 'as a selection mixing symbols and values' do
      subject{ rel[pid: :sid, test: ""] }

      let(:expected){ Alf::Relation(pid: 'S1', test: "") }

      it{ should eq(expected) }
    end

    context 'as a selection mixing list, then selection' do
      subject{ rel[:sid, pid: :sid, test: ""] }

      let(:expected){ Alf::Relation(sid: 'S1', pid: 'S1', test: "") }

      it{ should eq(expected) }
    end

    context 'as a projection' do
      subject{ rel[:sid, :city] }

      let(:expected){ Alf::Relation(sid: 'S1', city: "London") }

      it{ should eq(expected) }
    end

  end
end
