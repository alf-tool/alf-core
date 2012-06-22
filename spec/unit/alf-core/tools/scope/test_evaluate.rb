require 'spec_helper'
module Alf
  module Tools
    describe Scope, "evaluate" do

      let(:scope) { Scope.new [ HelpersInScope ] }

      it 'has available helpers in scope' do
        scope.evaluate{ hello(world) }.should eq("Hello world!")
      end

      it 'supports a string' do
        scope.evaluate("hello(world)").should eq("Hello world!")
      end

      it 'supports traceability on errors' do
        begin
          scope.evaluate("no_such_one", "a file", 65)
          raise "Should not pass here"
        rescue NameError => ex
          ex.backtrace.first.should =~ /a file:65/
        end
      end

    end
  end
end
