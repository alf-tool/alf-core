require 'spec_helper'
module Alf
  describe Reader::AlfFile do
    
    let(:io){ StringIO.new(expr) }
    def dataset(name)
      [{:status => 10},{:status => 30}]
    end
    subject{ Reader::AlfFile.new(io, self).to_a }

    describe "on pure functional expressions" do
      let(:expr){ "(restrict :suppliers, lambda{status > 20})" }
      it{ should == [{:status => 30}]}
    end
      
  end
end