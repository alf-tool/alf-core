require 'spec_helper'
module Alf
  describe Reader do
    
    subject{ Reader }
    it { should respond_to(:rash) }
      
    describe "rash" do
      subject{ Reader.rash($stdin) }
      it{ should be_a(Reader::Rash) }
    end
    
    describe "reader" do
      
      specify "when associated" do
        r = Reader.reader('suppliers.rash')
        r.should  be_a(Reader::Rash)
      end
      
      specify "when not associated" do
        lambda{ Reader.reader('.noone') }.should raise_error
      end
      
      specify "when an IO" do
        Reader.reader($stdin).should be_a(Reader::Rash)
      end
      
    end

  end
end