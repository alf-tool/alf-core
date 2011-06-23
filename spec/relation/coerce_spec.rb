require 'spec_helper'
require 'alf/relation'
module Alf
  describe Relation do
    
    let(:tuples_by_sid){[
      {:sid => 'S1', :name => 'Smith', :status => 20, :city => 'London'},
      {:sid => 'S2', :name => 'Jones', :status => 10, :city => 'Paris'},
      {:sid => 'S3', :name => 'Blake', :status => 30, :city => 'Paris'}
    ]}
    let(:rel){ Relation.new tuples_by_sid.to_set }
    let(:tuples_by_name){ tuples_by_sid.sort{|t1,t2| t1[:name] <=> t2[:name]} }
    
    describe "coerce" do
      
      subject{ Relation.coerce(arg) }
      
      describe "with a Relation" do
        let(:arg){ rel }
        it{ should be_a(Relation) }
        it{ should == rel } 
      end
    
      describe "with a set of tuples" do
        let(:arg){ tuples_by_name.to_set }
        it{ should be_a(Relation) }
        it{ should == rel }
      end
    
      describe "with an array of tuples" do
        let(:arg){ tuples_by_name }
        it{ should be_a(Relation) }
        it{ should == rel }
      end
      
      describe "with an iterator" do
        let(:arg){ Lispy.restrict(tuples_by_name, lambda{ true }) }
        it{ should be_a(Relation) }
        it{ should == rel }
      end
      
      describe "with unrecognized arg" do
        let(:arg){ nil }
        specify{ lambda{ subject }.should raise_error(ArgumentError) } 
      end

    end # coerce
      
  end
end