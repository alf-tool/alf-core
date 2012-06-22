require 'spec_helper'
module Alf
  module Tools
    describe TupleHandle, 'respond_to?' do

      context 'on an empty TupleHandle' do
        let(:handle){ TupleHandle.new }

        it_behaves_like "A scope"
      end

      context 'on a TupleHandle that decorates a tuple' do
        let(:handle){ TupleHandle.new(:hello => "world") }

        it_behaves_like "A scope"

        it 'responds to tuple keys' do
          handle.respond_to?(:hello).should be_true
        end
      end

      context 'on a TupleHandle that has helpers' do
        let(:handle){ TupleHandle.new(nil, [ HelpersInScope ]) }

        it_behaves_like "A scope"

        it "responds to helpers' methods" do
          handle.respond_to?(:hello).should be_true
        end
      end

    end
  end
end