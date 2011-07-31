require 'spec_helper'
module Alf
  module Tools
    describe Signature, "#parse_argv" do
      
      let(:receiver){ Object.new }
        
      describe "on a singleton signature with a ProjectionKey" do
        let(:signature){ Signature.new [[:proj, ProjectionKey]] }
        let(:argv){ [%w{hello world}] }
        specify{
          signature.install(class << receiver; self; end)
          signature.parse_argv(argv, receiver)
          receiver.proj.should eq(ProjectionKey.new([:hello, :world])) 
        }
      end
      
      describe "on a singleton signature with a default" do
        let(:signature){ Signature.new [[:attrname, AttrName, :autonum]] }
        let(:argv){ [%w{}] }
        specify{
          signature.install(class << receiver; self; end)
          signature.parse_argv(argv, receiver)
          receiver.attrname.should eq(:autonum) 
        }
      end
      
    end
  end
end
