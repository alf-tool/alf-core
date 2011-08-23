require 'spec_helper'
module Alf
  describe Environment::Folder do
    
    let(:path){ File.expand_path('../examples', __FILE__) }
    let(:env){ Environment::Folder.new(path) }
    
    specify ".recognizes?" do
      Environment::Folder.recognizes?([path]).should be_true
      Environment::Folder.recognizes?(["not/an/existing/one"]).should be_false
    end
        
    describe "dataset" do
      
      subject{ env.dataset(name) }
      
      describe "when called on explicit file" do
        let(:name){ "suppliers.rash" }
        it{ should be_a(Reader::Rash) }
      end
      
      describe "when called on existing" do
        let(:name){ "suppliers" }
        it{ should be_a(Reader::Rash) }
      end
      
      describe "when called on unexisting" do
        let(:name){ "notavalidone" }
        specify{ lambda{ subject }.should raise_error(Alf::NoSuchDatasetError) }
      end
      
    end
    
  end
end
