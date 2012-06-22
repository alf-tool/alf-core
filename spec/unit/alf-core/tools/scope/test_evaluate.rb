require 'spec_helper'
module Alf
  module Tools
    describe Scope, "evaluate" do

      context 'on a scope with helpers' do
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
            ex.backtrace.any?{|l| l =~ /a file:65/}.should be_true
          end
        end
      end

      context 'on a scope with a parent' do
        let(:here) { Module.new{ def here; 'here'; end } }
        let(:scope){ Scope.new [ here ], Scope.new([ HelpersInScope ]) }

        it 'delegates to the parent' do
          scope.evaluate{ hello(world) }.should eq("Hello world!")
        end

        it 'correctly respect the priorities' do
          scope.evaluate{ hello(here) }.should eq("Hello here!")
        end
      end

    end
  end
end
