require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Generator do
        
      let(:operator_class){ Generator }
      it_should_behave_like("An operator class")
        
      subject{ operator.to_rel }
  
      describe "without providing anything" do
        
        let(:expected){Relation[
          {:num => 1},
          {:num => 2},
          {:num => 3},
          {:num => 4},
          {:num => 5},
          {:num => 6},
          {:num => 7},
          {:num => 8},
          {:num => 9},
          {:num => 10},
        ]}
    
        describe "When factored with Lispy" do 
          let(:operator){ Lispy.generator() }
          it{ should == expected }
        end
    
        describe "When factored from commandline args" do
          let(:operator){ Generator.run(%w{}) }
          it{ should == expected }
        end
  
      end
      
      describe "when providing an size" do
        
        let(:expected){Relation[
          {:num => 1},
          {:num => 2},
        ]}
    
        describe "When factored with Lispy" do 
          let(:operator){ Lispy.generator(2) }
          it{ should == expected }
        end
    
        describe "When factored from commandline args" do
          let(:operator){ Generator.run(["--", "2"]) }
          it{ should == expected }
        end
  
      end
      
      describe "when providing a size and a name" do
        
        let(:expected){Relation[
          {:id => 1},
          {:id => 2},
        ]}
    
        describe "When factored with Lispy" do 
          let(:operator){ Lispy.generator(2, :id) }
          it{ should == expected }
        end
    
        describe "When factored from commandline args" do
          let(:operator){ Generator.run(["--", "2", "--", "id"]) }
          it{ should == expected }
        end
  
      end
      
    end 
  end
end
