require 'spec_helper'
module Alf
  module Tools
    describe TupleHandle, 'respond_to?' do

      after do
        handle.respond_to?(:anything_else).should be_false
      end

      context 'on an empty TupleHandle' do
        let(:handle){ TupleHandle.new }

        it 'responds to its private API' do
          handle.respond_to?(:__set_tuple).should be_true
        end

        it "responds to BasicObject's API" do
          handle.respond_to?(:instance_eval).should be_true
        end
      end

      context 'on a TupleHandle that decorates a tuple' do
        let(:handle){ TupleHandle.new(:hello => "world") }

        it 'responds to tuple keys' do
          handle.respond_to?(:hello).should be_true
        end
      end

      context 'on a TupleHandle that has helpers' do
        let(:handle){ TupleHandle.new(Module.new{ def i_am_a_helper; end }) }

        it "responds to helpers' methods" do
          handle.respond_to?(:i_am_a_helper).should be_true
        end
      end

    end
  end
end