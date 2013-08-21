require 'spec_helper'
module Alf
  module Support
    describe Config, '.option' do

      let(:conf1){
        Class.new(Config){
          option :ready, Boolean, false
          option :which, String, ->{ "foo" }
          option :done,  Proc, ->{ "bar" }
        }
      }

      let(:conf2){
        Class.new(Config){
          option :hello, String, "world"
        }
      }

      it 'does not mix subclasses' do
        conf1.new.should respond_to(:ready?)
        conf2.new.should_not respond_to(:ready?)
        conf1.new.should_not respond_to(:hello)
        conf2.new.should respond_to(:hello)
      end

      it 'supports procs' do
        conf1.new.which.should eq("foo")
      end

      it 'does not confuse procs' do
        conf1.new.done.should be_a(Proc)
      end

    end
  end
end
