require 'spec_helper'
module Alf
  module Tools
    describe Signature, "#parse_argv" do
      
      let(:clazz){ Class.new(Object) }
      let(:receiver){ clazz.new }
      before{ 
        signature.install 
      }
      subject{
        signature.parse_argv(argv, receiver)
      }
 
      describe "on a singleton signature with a AttrList" do
        let(:signature){ 
          Signature.new(clazz) do |s|
            s.argument :proj, AttrList
          end
        }
        let(:argv){ %w{-- hello world} }
        specify{
          subject.should eq([])
          receiver.proj.should eq(AttrList.new([:hello, :world])) 
        }
      end
      
      describe "on a singleton signature with a default" do
        let(:signature){ 
          Signature.new(clazz) do |s|
            s.argument :attrname, AttrName, :autonum
          end
        }
        let(:argv){ %w{} }
        specify{
          subject.should eq([])
          receiver.attrname.should eq(:autonum) 
        }
      end

      describe "On quota signature" do
        let(:signature){
          Signature.new(clazz) do |s|
            s.argument :by, AttrList, []
            s.argument :order, Ordering, []
            s.argument :summarization, Summarization, {}
          end
        }
        let(:argv){ %w{op1 -- a -- time -- time_sum sum(:time) time_max max(:time)} }
        specify{
          subject.should eq(["op1"])
          receiver.by.should eq(AttrList.new([:a]))
          receiver.order.should eq(Ordering.coerce([:time]))
        }
      end

      describe "When signature contains options" do
        let(:signature){
          Signature.new(clazz) do |s|
            s.argument :by, AttrList, []
            s.option :allbut, Boolean, false, "Allbut?"
          end
        }

        describe "when options are specified" do
          let(:argv){ %w{op1 --allbut -- a} }
          specify{
            subject.should eq(["op1"])
            receiver.by.should eq(AttrList.new([:a]))
            receiver.allbut.should eql(true)
          }
        end

        describe "when options are not specified" do
          let(:argv){ %w{op1 -- a} }
          specify{
            subject.should eq(["op1"])
            receiver.by.should eq(AttrList.new([:a]))
            receiver.allbut.should eql(false)
          }
        end

      end
      
    end
  end
end
