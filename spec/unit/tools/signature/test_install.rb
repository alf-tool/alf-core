require 'spec_helper'
module Alf
  module Tools
    describe Signature, '.install' do
      
      let(:clazz){ Class.new(Object) }
      subject{ signature.install(clazz) }
      
      describe "on an empty signature" do
        let(:signature){ Signature.new [] }
        specify{
          lambda{ subject }.should_not raise_error
        }
      end
      
      describe "on a  non empty signature" do

        let(:signature){ 
          Signature.new do |s|
            s.argument :attrname, AttrName
            s.argument :ordering, OrderingKey
            s.option   :allbut,   Boolean
          end 
        }

        it "should have arguments installed as attr accessors" do
          subject
          inst = clazz.new
          inst.should respond_to(:attrname)
          inst.send(:"attrname=", :hello)
          inst.attrname.should eq(:hello)
        end
   
        it "should have options installed as attr accessors" do
          subject
          inst = clazz.new
          inst.should respond_to(:allbut)
          inst.send(:"allbut=", true)
          inst.allbut.should be_true
        end

        it "should apply auto-coercion" do
          subject
          inst = clazz.new
          inst.send(:"allbut=", "true")
          inst.allbut.should be_true
        end

      end
      
    end
  end
end
