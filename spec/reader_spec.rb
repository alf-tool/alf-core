require 'spec_helper'
module Alf
  describe Reader do
    
    subject{ Reader }
    it { should respond_to(:rash) }
      
    describe "rash" do
      subject{ Reader.rash($stdin) }
      it{ should be_a(Reader::Rash) }
    end
    
    describe "reader_class_by_file_extension" do
      
      describe "when associated" do
        subject{ Reader.reader_class_by_file_extension('.rash') }
        it { should == Reader::Rash }
      end
      
      describe "when not associated" do
        subject{ Reader.reader_class_by_file_extension('.noone') }
        it { should be_nil }
      end
      
    end

  end
end