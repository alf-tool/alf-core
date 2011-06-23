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
      
    specify "union" do
      (rel1 + rel1).should == rel1
      (rel1 + rel2).should == rel(
        {:sid => 'S1'},
        {:sid => 'S3'},
        {:sid => 'S2'},
        {:sid => 'S5'}
      )
    end # coerce
      
  end
end