require 'spec_helper'
module Alf
  module Tools
    describe Signature, "#parse_args" do
      
      let(:clazz){ Class.new(Object) }
      let(:receiver){ clazz.new }
      before{ 
        signature.install(clazz) 
      }
      subject{
        signature.parse_args(args, receiver)
        receiver
      }
        
      describe "on a singleton signature with a ProjectionKey" do
        let(:signature){ Signature.new [[:proj, ProjectionKey]] }
        let(:args){ [%w{hello world}] }
        specify{
          subject.proj.should eq(ProjectionKey.new([:hello, :world])) 
        }
      end
      
      describe "on a singleton signature with a default" do
        let(:signature){ Signature.new [[:attrname, AttrName, :autonum]] }
        let(:args){ [] }
        specify{
          subject.attrname.should eq(:autonum) 
        }
      end
      
      describe "on a signature with options" do
        let(:signature){
          Signature.new do |s|
            s.argument :key, ProjectionKey, []
            s.option   :allbut, Boolean, false
          end
        }

        describe "when no option is provided" do
          let(:args){ [[:hello, :world]] }
          specify{
            subject.key.should eql(ProjectionKey.new([:hello, :world]))
            subject.allbut.should eql(false)
          }
        end

      end

    end
  end
end
