require 'spec_helper'
module Alf
  module Support
    describe Bindable, "connection" do

      let(:clazz){
        Class.new{
          include Bindable
          def initialize(conn = nil)
            @connection = conn
          end
        }
      }

      subject{ bindable.connection }

      context 'on an unbound object' do
        let(:bindable){ clazz.new }

        it{ should be_nil }
      end

      context 'on a bound object' do
        let(:bindable){ clazz.new(self) }

        it{ should be(self) }
      end

    end
  end
end