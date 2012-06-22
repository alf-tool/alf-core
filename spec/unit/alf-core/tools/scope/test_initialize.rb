require 'spec_helper'
module Alf
  module Tools
    describe Scope, 'initialize' do

      it 'supports no argument' do
        lambda{ Scope.new }.should_not raise_error
      end

      it 'supports an array of modules' do
        lambda{ Scope.new([ Helpers ]) }.should_not raise_error
      end

    end
  end
end