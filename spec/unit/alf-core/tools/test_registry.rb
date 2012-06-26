require 'spec_helper'
module Alf
  module Tools
    describe Registry do

      let(:clazz){ Class.new.extend(Registry) }

      describe 'when used with classes' do
        before do
          clazz.register(Integer, clazz)
        end

        it 'installs class-level methods' do
          clazz.should respond_to(:integer)
        end

        it 'add the class to the registered elements' do
          clazz.registered.should eq([Integer])
          clazz.all.should eq([Integer])
        end
      end

      describe 'when used with an array and arguments' do
        before do
          clazz.register([:hello, Integer], clazz)
        end

        it 'installs class-level methods' do
          clazz.should respond_to(:hello)
        end

        it 'maintain the registered elements' do
          clazz.registered.should eq([[:hello, Integer]])
        end
      end

    end
  end
end