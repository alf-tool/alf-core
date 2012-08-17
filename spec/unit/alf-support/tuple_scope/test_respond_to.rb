require 'spec_helper'
module Alf
  module Support
    describe TupleScope, 'respond_to?' do

      context 'on an empty TupleScope' do
        let(:scope){ TupleScope.new }

        it_behaves_like "A scope"
      end

      context 'on a TupleScope that decorates a tuple' do
        let(:scope){ TupleScope.new(:hello => "world") }

        it_behaves_like "A scope"

        it 'responds to tuple keys' do
          scope.respond_to?(:hello).should be_true
        end
      end

      context 'on a TupleScope that has helpers' do
        let(:scope){ TupleScope.new(nil, [ HelpersInScope ]) }

        it_behaves_like "A scope"

        it "responds to helpers' methods" do
          scope.respond_to?(:hello).should be_true
        end
      end

    end
  end
end