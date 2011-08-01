require 'spec_helper'
module Alf
  describe Relation do
    
    let(:rel1){rel(
      {:sid => 'S1'},
      {:sid => 'S2'},
      {:sid => 'S3'}
    )}
    
    let(:rel2){rel(
      {:sid => 'S5'},
      {:sid => 'S2'}
    )}

    specify "project" do
      rel1.project([]).should eq(rel({}))
      rel1.project([:sid], true).should eq(rel({}))
    end
    
    specify "allbut" do
      rel1.allbut([:sid]).should eq(rel({}))
    end
    
    specify "extend" do
      rel1.extend(:x => lambda{ sid.downcase }).should == rel(
        {:sid => 'S1', :x => 's1'},
        {:sid => 'S2', :x => 's2'},
        {:sid => 'S3', :x => 's3'}
      )
    end
      
    specify "union" do
      (rel1 + rel1).should == rel1
      (rel1 + rel2).should == rel(
        {:sid => 'S1'},
        {:sid => 'S3'},
        {:sid => 'S2'},
        {:sid => 'S5'}
      )
    end # coerce
      
    specify "difference" do
      (rel1 - rel1).should == rel()
      (rel1 - rel2).should == rel(
        {:sid => 'S1'},
        {:sid => 'S3'}
      )
      (rel2 - rel1).should == rel(
        {:sid => 'S5'}
      )
    end # coerce
    
  end
end