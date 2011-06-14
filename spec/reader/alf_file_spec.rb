require File.expand_path('../../spec_helper', __FILE__)
require 'stringio'
class Alf
  describe Reader::AlfFile do
    
    let(:io){ StringIO.new "(restrict :suppliers, lambda{status > 20})" }
    let(:reader){ Reader::AlfFile.new(io, self) } 
    def dataset(name)
      [{:status => 10},{:status => 30}]
    end
    
    subject{ reader.to_a }
    it{ should == [{:status => 30}]}
      
  end
end