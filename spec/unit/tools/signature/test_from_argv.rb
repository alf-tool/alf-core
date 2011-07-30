require 'spec_helper'
module Alf
  module Tools
    describe Signature, "#from_argv" do
      
      subject{ signature.from_argv(argv) }
        
      describe "on an empty signature" do
        let(:signature){ Signature.new [] }
        let(:argv){ [] }
        it{ should eq([]) }
      end
      
      describe "on a  singleton signature on AttrName" do
        let(:signature){ Signature.new [[:attr, AttrName]] }
        let(:argv){ %w{hello} }
        it{ should eq([:hello]) }
      end
      
      describe "on a singleton signature on a ProjectionKey" do
        let(:signature){ Signature.new [[:attr, ProjectionKey]] }
        let(:argv){ %w{hello world} }
        it{ should eq([ProjectionKey.new([:hello, :world])]) }
      end
      
      describe "on quota's signature" do
        let(:signature){ 
          Signature.new [
            [:by,    ProjectionKey], 
            [:order, OrderingKey], 
            [:summ,  Summarization]
          ] 
        }
        let(:argv){ %w{sid -- name desc qty asc -- pos count} }
        specify {
          proj, order, summ = subject
          proj.should eq(ProjectionKey.new([:sid]))
          order.should eq(OrderingKey.new([[:name, :desc], [:qty, :asc]]))
          summ.should be_a(Summarization)
        }
      end
      
    end
  end
end
