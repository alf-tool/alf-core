require 'spec_helper'
module Alf
  describe Relation, '[]' do

    let(:rel){ Alf::Relation(sid: 'S1', sname: "Jones", city: "London") }

    context 'as a renaming' do
      subject{ rel[:sid => :pid] }

      let(:expected){ Alf::Relation(pid: 'S1', sname: "Jones", city: "London") }

      it{ should eq(expected) }
    end

    context 'as a projection' do
      subject{ rel[:sid, :city] }

      let(:expected){ Alf::Relation(sid: 'S1', city: "London") }

      it{ should eq(expected) }
    end

  end
end
