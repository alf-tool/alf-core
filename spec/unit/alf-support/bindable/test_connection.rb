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

        it 'raises an UnboundError' do
          lambda{
            subject
          }.should raise_error(UnboundError)
        end
      end

      context 'on a bound object' do
        let(:bindable){ clazz.new(self) }

        it{ should be(self) }
      end

    end
  end
end
