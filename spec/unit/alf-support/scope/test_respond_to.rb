require 'spec_helper'
module Alf
  module Support
    describe Scope, 'respond_to?' do

      context 'on an empty Scope' do
        subject{ Scope.new }
        it_behaves_like "A scope"
      end

      context 'on a Scope that has helpers' do
        subject{ Scope.new [ HelpersInScope ] }

        it_behaves_like "A scope"

        it "responds to helpers' methods" do
          subject.respond_to?(:world).should be_true
        end
      end

      context 'on a Scope that has a parent scope' do
        subject{ Scope.new [ ], Scope.new([ HelpersInScope ]) }

        it_behaves_like "A scope"

        it "responds to parent scope methods" do
          subject.respond_to?(:world).should be_true
        end
      end

    end
  end
end