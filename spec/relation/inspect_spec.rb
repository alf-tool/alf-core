require 'spec_helper'
module Alf
  describe Relation do
    
    let(:rel){Relation.coerce([
      {:sid => 'S1'},
      {:sid => 'S2'},
      {:sid => 'S3'}
    ])}
    
    describe "inspect" do
      
      it "should allows the litteral round-trip" do
        Kernel.eval(rel.inspect).should == rel
      end

    end # coerce
      
  end
end