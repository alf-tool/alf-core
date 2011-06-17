require 'spec_helper'
module Alf
  describe Autonum do
      
    let(:operator_class){ Autonum }
    it_should_behave_like("An operator class")
      
    let(:input) {[
      {:a => "a"},
      {:a => "b"},
      {:a => "a"},
    ]}

    subject{ operator.to_a }

    describe "without providing an attribute name" do
      
      let(:expected){[
        {:a => "a", :autonum => 0},
        {:a => "b", :autonum => 1},
        {:a => "a", :autonum => 2},
      ]}
  
      describe "When factored with Lispy" do 
        let(:operator){ Lispy.autonum(input) }
        it{ should == expected }
      end
  
      describe "When factored from commandline args" do
        let(:operator){ Autonum.run([]) }
        before{ operator.pipe(input) }
        it{ should == expected }
      end

    end
    
    describe "when providing an attribute name" do
      
      let(:expected){[
        {:a => "a", :unique => 0},
        {:a => "b", :unique => 1},
        {:a => "a", :unique => 2},
      ]}
  
      describe "When factored with Lispy" do 
        let(:operator){ Lispy.autonum(input, :unique) }
        it{ should == expected }
      end
  
      describe "When factored from commandline args" do
        let(:operator){ Autonum.run(["--", "unique"]) }
        before{ operator.pipe(input) }
        it{ should == expected }
      end

    end
    
  end 
end
