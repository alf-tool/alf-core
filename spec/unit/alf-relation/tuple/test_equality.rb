require 'spec_helper'
module Alf
  module Types
    describe Tuple, '==' do

      subject{ object == other }

      let(:object){ Tuple name: 'Alf' }

      context 'on self' do
        let(:other){ object }

        it{ should be_true }
      end

      context 'on a dup' do
        let(:other){ object.dup }

        it{ should be_true }
      end

      context 'on an equivalent' do
        let(:other){ Tuple name: 'Alf' }

        it{ should be_true }
      end

      context 'when embedded in a set' do
        let(:object){ Set.new << Tuple(name: 'Alf') }
        let(:other) { Set.new << Tuple(name: 'Alf') }

        it 'should still be equal' do
          object.should eq(other)
        end
      end

    end
  end
end