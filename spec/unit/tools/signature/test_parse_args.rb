require 'spec_helper'
module Alf
  module Tools
    describe Signature, "#parse_args" do
      
      let(:receiver){ Object.new }
        
      describe "on a singleton signature with a ProjectionKey" do
        let(:signature){ Signature.new [[:proj, ProjectionKey]] }
        let(:args){ [%w{hello world}] }
        specify{
          signature.install(class << receiver; self; end)
          signature.parse_args(args, receiver)
          receiver.proj.should eq(ProjectionKey.new([:hello, :world])) 
        }
      end
      
      describe "on a singleton signature with a default" do
        let(:signature){ Signature.new [[:attrname, AttrName, :autonum]] }
        let(:args){ [] }
        specify{
          signature.install(class << receiver; self; end)
          signature.parse_args(args, receiver)
          receiver.attrname.should eq(:autonum) 
        }
      end
      
    end
  end
end
