require 'spec_helper'
module Alf
  describe Environment do
    
    subject{ Environment }
    it { should respond_to(:folder) }
      
    describe "folder" do
      subject{ Environment.folder(File.dirname(__FILE__)) }
      it{ should be_a(Environment::Folder) }
    end
    
    describe "autodetect" do
      
      it "should recognize an existing folder" do
        env = Environment.autodetect(File.dirname(__FILE__))
        env.should be_a(Environment::Folder)
      end
      
      it "should raise an Argument when no match" do
        lambda{ Environment.autodetect(12) }.should raise_error(ArgumentError)
      end
      
    end

  end
end