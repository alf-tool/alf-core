require 'spec_helper'
module Alf
  module Tools
    describe "#tuple_heading" do
      
      subject{ Tools.tuple_heading(tuple) }

      describe 'on the empty tuple' do
        let(:tuple){ {} }
        it { should == Heading::EMPTY }
      end
     
      describe 'on a supplier-like tuple' do
        let(:tuple){ {:name => "Jones", :old => false} }
        it { should == Heading[:name => String, :old => FalseClass] }
      end
     
    end
  end
end
