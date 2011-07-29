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
        it{ should eq(Renaming.new(:old => :new)) }
      end
      
      describe "from an Array" do
        let(:arg){ ["old", "new"] }
        it{ should eq(Renaming.new(:old => :new)) }
      end
        
    end
    
    describe "from_argv" do
      
      subject{ Renaming.from_argv(argv) }
      
      describe "from an empty Array" do
        let(:argv){ [] }
        it{ should eq(Renaming.new({})) }
      end
        
      describe "from an Array of two elements" do
        let(:argv){ ["old", "new"] }
        it{ should eq(Renaming.new(:old => :new)) }
      end
        
      describe "from an Array of four elements" do
        let(:argv){ ["old", "new", "hello", "world"] }
        it{ should eq(Renaming.new(:old => :new, :hello => :world)) }
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