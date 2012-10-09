require 'spec_helper'
module Alf
  module Support
    describe Bindable, "bound?" do

      let(:clazz){
        Class.new{
          include Bindable
          def initialize(conn = nil)
            @connection = conn
          end
        }
      }

      subject{ bindable.bound? }

      context 'on an unbound object' do
        let(:bindable){ clazz.new }

        it{ should be_false }
      end

      context 'on a bound object' do
        let(:bindable){ clazz.new(self) }

        it{ should be_true }
      end

    end
  end
end
