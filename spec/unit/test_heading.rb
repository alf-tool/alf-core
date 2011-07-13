require 'spec_helper'
module Alf
  describe Heading do
    
    let(:h0){ Heading.new({}) }
    let(:h1){ Heading.new(:name => String) }
    let(:h2){ Heading.new(:name => String, :price => Float) }
    
    specify "cardinality" do
      h0.cardinality.should eq(0)
      h1.cardinality.should eq(1)
      h2.cardinality.should eq(2)
    end
    
    specify "to_hash" do
      h0.to_hash.should eq({})
      h1.to_hash.should eq(:name => String)
      h2.to_hash.should eq(:name => String, :price => Float)
    end
    
    describe "EMPTY" do
      subject{ Heading::EMPTY }
      it_should_behave_like "A value" 
    end
    
    describe "h0" do
      subject{ h0 }
      it { should == Heading::EMPTY }
      it_should_behave_like "A value" 
    end
    
    describe "h1" do
      subject{ h1 }
      it_should_behave_like "A value" 
    end
    
  end 
end