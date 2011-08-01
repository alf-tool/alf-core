require 'spec_helper'
module Alf
  module Tools
    describe Signature, '.install' do
      
      let(:clazz){
        Class.new(Object)
      }
      subject{ signature.install(clazz) }
      
      describe "on an empty signature" do
        let(:signature){ Signature.new [] }
        specify{
          lambda{ subject }.should_not raise_error
        }
      end
      
      describe "on a  non empty signature" do
        let(:signature){ Signature.new [
            [:attrname, AttrName],
            [:ordering, OrderingKey]
          ] 
        }
        specify {
          subject
          inst = clazz.new
          inst.should respond_to(:attrname)
          inst.send(:"attrname=", :hello)
          inst.attrname.should eq(:hello)
        }
      end
      
    end
  end
end