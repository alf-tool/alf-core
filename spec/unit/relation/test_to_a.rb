require 'spec_helper'
module Alf
  describe "Relation#to_a" do
    
    let(:rel){Alf::Relation[
      {:sid => 'S2'},
      {:sid => 'S1'},
      {:sid => 'S3'}
    ]}
    
    specify "without an ordering key" do
      rel.to_a.sort{|k1,k2| k1[:sid] <=> k2[:sid]}.should eq([
        {:sid => 'S1'},
        {:sid => 'S2'},
        {:sid => 'S3'}
      ])
    end
      
    specify "with an ordering key" do
      rel.to_a([:sid]).should eq([
        {:sid => 'S1'},
        {:sid => 'S2'},
        {:sid => 'S3'}
      ])
      rel.to_a([[:sid, :desc]]).should eq([
        {:sid => 'S3'},
        {:sid => 'S2'},
        {:sid => 'S1'}
      ])
    end
    
    specify "ON DUM" do
      Relation::DUM.to_a.should eq([])
    end
    
    specify "ON DEE" do
      Relation::DEE.to_a.should eq([{}])
    end
    
  end
end