require 'spec_helper'
module Alf
  module Tools
    describe Signature, "#parse_argv" do
      
      let(:clazz){ Class.new(Object) }
      let(:receiver){ clazz.new }
      before{ 
        signature.install(clazz) 
      }
      subject{
        signature.parse_argv(argv, receiver)
      }
 
      describe "on a singleton signature with a ProjectionKey" do
        let(:signature){ Signature.new [[:proj, ProjectionKey]] }
        let(:argv){ %w{-- hello world} }
        specify{
          subject.should eq([])
          receiver.proj.should eq(ProjectionKey.new([:hello, :world])) 
        }
      end
      
      describe "on a singleton signature with a default" do
        let(:signature){ Signature.new [[:attrname, AttrName, :autonum]] }
        let(:argv){ %w{} }
        specify{
          subject.should eq([])
          receiver.attrname.should eq(:autonum) 
        }
      end

      describe "On quota signature" do
        let(:signature){
          Signature.new do |s|
            s.argument :by, ProjectionKey, []
            s.argument :order, OrderingKey, []
            s.argument :summarization, Summarization, {}
          end
        }
        let(:argv){ %w{op1 -- a -- time -- time_sum sum(:time) time_max max(:time)} }
        specify{
          subject.should eq(["op1"])
          receiver.by.should eq(ProjectionKey.new([:a]))
          receiver.order.should eq(OrderingKey.coerce([:time]))
        }
      end

      describe "When signature contains options" do
        let(:signature){
          Signature.new do |s|
            s.argument :by, ProjectionKey, []
            s.option :allbut, Boolean, false, "Allbut?"
          end
        }

        describe "when options are specified" do
          let(:argv){ %w{op1 --allbut -- a} }
          specify{
            subject.should eq(["op1"])
            receiver.by.should eq(ProjectionKey.new([:a]))
            receiver.allbut.should eql(true)
          }
        end

        describe "when options are not specified" do
          let(:argv){ %w{op1 -- a} }
          specify{
            subject.should eq(["op1"])
            receiver.by.should eq(ProjectionKey.new([:a]))
            receiver.allbut.should eql(false)
          }
        end

      end
      
    end
  end
end
