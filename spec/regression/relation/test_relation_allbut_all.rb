require 'spec_helper'
require 'date'
module Alf
  describe Relation, "allbut" do
  
    describe "when all attributes are projected away" do
      before{ puts "--"*20 }
      after{ puts "--"*20 }
      subject{ 
        Relation[{:sid => "P1"}].allbut([:sid]) 
      }
      it{ should eql(Relation[{}]) }
    end
    
  end
end
