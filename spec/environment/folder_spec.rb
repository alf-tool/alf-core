require File.expand_path('../../spec_helper', __FILE__)
class Alf
  describe Environment::Folder do
    
    let(:path){ File.expand_path('../../../examples', __FILE__) }
    let(:env){ Environment::Folder.new(path) }
      
    describe "dataset" do
      
      subject{ env.dataset(name) }
      
      describe "when called on existing" do
        let(:name){ "suppliers" }
        it{ should be_a(Reader::Rash) }
      end
      
      describe "when called on unexisting" do
        let(:name){ "notavalidone" }
        specify{ lambda{ subject }.should raise_error }
      end
      
    end
    
  end
end