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
        receiver
      }
 
      describe "on a singleton signature with a ProjectionKey" do
        let(:signature){ Signature.new [[:proj, ProjectionKey]] }
        let(:argv){ [%w{hello world}] }
        specify{
          subject.proj.should eq(ProjectionKey.new([:hello, :world])) 
        }
      end
      
      describe "on a singleton signature with a default" do
        let(:signature){ Signature.new [[:attrname, AttrName, :autonum]] }
        let(:argv){ [%w{}] }
        specify{
          subject.attrname.should eq(:autonum) 
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
        let(:argv){ [%w{a}, %w{time}, %w{time_sum sum(:time) time_max max(:time)}] }
        specify{
          subject.by.should eq(ProjectionKey.new [:a])
        }
      end
      
    end
  end
end
