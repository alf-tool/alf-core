require 'spec_helper'
module Alf
  describe Renaming do
    
    describe "coerce" do
      
      subject{ Renaming.coerce(arg) }
      
      describe "from a Renaming" do
        let(:arg){ Renaming.new(:old => :new) }
        it{ should eq(arg) }
      end
      
      describe "from a Hash" do
        let(:arg){ {"old" => "new"} }
        specify{ subject.renaming.should eq(:old => :new) }
      end
      
      describe "from an Array" do
        let(:arg){ ["old", "new"] }
        specify{ subject.renaming.should eq(:old => :new) }
      end
        
    end
    
    describe "apply" do
      let(:r){ Renaming.coerce(["old", "new"])} 
      specify{
        r.apply(:old => :a, :other => :b).should eql(:new => :a, :other => :b)
      }
    end
    
  end 
end