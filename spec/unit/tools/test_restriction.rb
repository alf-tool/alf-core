require 'spec_helper'
module Alf
  module Tools
    describe Restriction do

      let(:handle){ TupleHandle.new.set(:old => true) }
      subject{ Restriction.coerce(arg).evaluate(handle) }
      
      describe "from Restriction" do
        let(:arg){ Restriction.new(lambda{ !old }) }
        it{ should eql(false) }
      end
        
      describe "from Proc" do
        let(:arg){ lambda{ old } }
        it{ should eql(true) }
      end
      
      describe "from String" do
        let(:arg){ "!old" }
        it{ should eql(false) }
      end
      
      describe "from Symbol" do
        let(:arg){ :old }
        it{ should eql(true) }
      end
      
      describe "from Hash" do
        let(:arg){ {:old => false} }
        it{ should eql(false) }
      end
      
      describe "from Array" do
        let(:arg){ ["old", "false"] }
        it{ should eql(false) }
      end
      
    end
  end
end