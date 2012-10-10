require 'spec_helper'
module Alf
  module Support
    describe Config, '.option' do

      let(:conf1){
        Class.new(Config){
          option :ready, Boolean, false
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

    end
  end
end
