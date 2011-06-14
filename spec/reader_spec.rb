require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Reader do
    
    subject{ Reader }
    it { should respond_to(:rash) }
      
    describe "rash" do
      subject{ Reader.rash($stdin) }
      it{ should be_a(Reader::Rash) }
    end

  end
end