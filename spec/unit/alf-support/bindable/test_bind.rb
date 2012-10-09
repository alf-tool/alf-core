require 'spec_helper'
module Alf
  module Support
    describe Bindable, "bind" do

      let(:bindable){ clazz.new  }
      let(:conn)    { Object.new }

      subject{ bindable.bind(conn) }

      context 'when called from the ouside' do
        let(:clazz){
          Class.new{ include Bindable }
        }

        it 'returns a dup of the original bindable' do
          subject.should be_a(clazz)
          subject.should_not be(bindable)
        end

        it 'sets the connection on the new one' do
          subject.connection.should be(conn)
        end

        it 'lets the original one unchanged' do
          lambda{
            bindable.connection
          }.should raise_error(UnboundError)
        end
      end

      context 'when called from a subclass' do
        let(:clazz){
          Class.new{
            attr_accessor :name
            include Bindable
            def initialize
              @name = "default"
            end
            def bind(conn)
              super(conn){|c| c.name = "changed" }
            end
          }
        }

        it 'sets the connection on the new one' do
          subject.connection.should be(conn)
        end

        it 'returns a copy with name being changed' do
          subject.name.should eq("changed")
        end

        it 'lets the original one unchanged' do
          bindable.name.should eq("default")
          lambda{
            bindable.connection
          }.should raise_error(UnboundError)
        end
      end

    end
  end
end
