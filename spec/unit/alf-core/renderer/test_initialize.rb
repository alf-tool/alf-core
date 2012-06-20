require 'spec_helper'
module Alf
  describe "Renderer#initialize" do
    
    subject{ Renderer.new(*args) }
    
    describe "with full args" do
      let(:args){[
        [], Database.examples, {:opts => true}
      ]}
      specify {
        subject.input.should eq([])
        subject.database.should be_a(Database)
        subject.options.should eq(:opts => true)
      }
    end
    
    describe "with only options" do
      let(:args){[
        {:opts => true}
      ]}
      specify {
        subject.input.should be_nil
        subject.database.should be_nil
        subject.options.should eq(:opts => true)
      }
    end

    describe "on a subclass" do
      class FooRenderer < Renderer
        DEFAULT_OPTIONS = {:from => :subclass}
      end
      subject{ FooRenderer.new(*args) }
        
      describe "without option overriding" do
        let(:args){[
          {:opts => true}
        ]}
        specify {
          subject.input.should be_nil
          subject.database.should be_nil
          subject.options.should eq(:opts => true, :from => :subclass)
        }
      end
      
      describe "with option overriding" do
        let(:args){[
          {:opts => true, :from => :overrided}
        ]}
        specify {
          subject.input.should be_nil
          subject.database.should be_nil
          subject.options.should eq(:opts => true, :from => :overrided)
        }
      end
      
    end
    
  end
end