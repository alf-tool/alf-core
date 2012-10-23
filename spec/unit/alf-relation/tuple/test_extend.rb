require 'spec_helper'
module Alf
  module Types
    describe Tuple, "extend" do

      let(:tuple){
        Tuple(id: 1, name: "Alf")
      }

      context 'without name clash' do
        subject{ tuple.extend(up: lambda{ name.upcase }) }

        it { should eq(Tuple(id: 1, name: "Alf", up: "ALF")) }
      end

      context 'with name clash' do
        subject{ tuple.extend(name: lambda{ name.upcase }) }

        it { should eq(Tuple(id: 1, name: "ALF")) }
      end

      context 'with type clash' do
        subject{ tuple.extend(name: lambda{ name.length }) }

        it { should eq(Tuple(id: 1, name: 3)) }
      end

    end
  end
end