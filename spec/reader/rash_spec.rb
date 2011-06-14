require File.expand_path('../../spec_helper', __FILE__)
require 'stringio'
class Alf
  describe Reader::Rash do

    let(:lines){ [{:id => 1},{:id => 2}]                 }
    let(:str)  { lines.collect{|s| s.inspect}.join("\n") }
    let(:io)   { StringIO.new(str) }

    describe "when called on a StringIO" do
      
      let(:reader){ Reader::Rash.new(io) }
  
      it "should be enumerable" do
        reader.to_a.should == lines
      end

    end
    
    describe "when called on a String" do
      
      let(:file){ File.expand_path('../input.rb', __FILE__) }
      let(:reader){ Reader::Rash.new(file) }
  
      it "should be enumerable" do
        reader.to_a.should == lines
      end

    end
    
  end
end
