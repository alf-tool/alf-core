require 'spec_helper'
module Alf
  module Support
    describe Config, 'option setter' do

      let(:conf_subclass){
        Class.new(Config){
          option :ready, Boolean, false
          option :which, String, ->{ "foo" }
          option :done, Proc, ->{ "bar" }
        }
      }

      let(:config){ conf_subclass.new }

      context 'on `ready` with a boolean' do
        subject{ config.ready = true }

        it 'should return the value' do
          subject.should eq(true)
        end

        it 'should set the value' do
          subject
          config.ready?.should eq(true)
        end
      end

      context 'on `ready` with needed coercion' do
        subject{ config.ready = "true" }

        it 'returns the non-coerced value' do
          subject.should eq("true")
        end

        it 'should set the value' do
          subject
          config.ready?.should eq(true)
        end
      end

      context 'on `which` with a string' do
        subject{ config.which = "blah" }

        it 'should return the value' do
          subject.should eq("blah")
        end

        it 'should set the value' do
          subject
          config.which.should eq("blah")
        end
      end

      context 'on `which` with a Proc' do
        let(:proc){ ->{ "blah" } }

        subject{ config.which = proc }

        it 'should return the value' do
          subject.should be(proc)
        end

        it 'should call the proc when option is get' do
          subject
          config.which.should eq("blah")
        end
      end

    end
  end
end
