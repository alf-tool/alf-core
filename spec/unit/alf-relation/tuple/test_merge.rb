require 'spec_helper'
module Alf
  module Types
    describe Tuple, "merge" do

      let(:tuple){ Tuple(id: 10, name: "Smith") }

      subject{ tuple.merge(other) }

      context 'without name clash' do
        let(:other){ Tuple(status: 30) }

        it{ should eq(Tuple(id: 10, name: "Smith", status: 30)) }
      end

      context 'with clash' do
        let(:other){ Tuple(id: 20, status: 30) }

        it{ should eq(Tuple(id: 20, name: "Smith", status: 30)) }
      end

    end
  end
end
