require 'spec_helper'
require 'alf/relation'
module Alf
  describe Relation do
 
    let(:tuples){[
      {:sid => 'S1', :name => 'Smith', :status => 20, :city => 'London'},
      {:sid => 'S2', :name => 'Jones', :status => 10, :city => 'Paris'},
      {:sid => 'S3', :name => 'Blake', :status => 30, :city => 'Paris'}
    ]}
    let(:tuples2){ tuples.sort{|t1,t2| t1[:name] <=> t2[:name]} }
    
    let(:rel1){ Relation.new(tuples.to_set) }
    let(:rel2){ Relation.new(tuples2.to_set) }
    let(:rel3){ Relation.new(tuples[0..1].to_set) }
    
    it "should define == correctly" do
      rel1.should == rel2
      rel2.should == rel1
      rel3.should_not == rel1
    end
    
    it "should allow putting them in hashes" do
      h = {}
      h[rel1] = 1
      h[rel2] = 2
      h[rel3] = 3
      h.size.should == 2
      h[rel1].should == 2
    end
      
  end
end