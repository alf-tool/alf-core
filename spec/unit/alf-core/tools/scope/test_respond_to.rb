require 'spec_helper'
module Alf
  module Tools
    describe Scope, 'respond_to?' do

      shared_examples_for "A Scope instance" do
        it 'responds to its own methods' do
          subject.respond_to?(:respond_to?).should be_true
          subject.respond_to?(:evaluate).should be_true
          subject.respond_to?(:__eval_binding).should be_true
        end

        it "responds to BasicObject's API" do
          subject.respond_to?(:instance_eval).should be_true
        end
        
        it 'does not respond to anything' do
          subject.respond_to?(:anything_else).should be_false
        end
      end

      context 'on an empty Scope' do
        subject{ Scope.new }
        it_behaves_like "A Scope instance"
      end

      context 'on a Scope that has helpers' do
        subject{ Scope.new([Module.new{ def i_am_a_helper; end }]) }

        it_behaves_like "A Scope instance"

        it "responds to helpers' methods" do
          subject.respond_to?(:i_am_a_helper).should be_true
        end
      end

    end
  end
end