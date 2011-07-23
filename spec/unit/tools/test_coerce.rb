require 'spec_helper'
module Alf
  describe "Tools#coerce" do
    
    specify {
      Tools.coerce("12", Integer).should eql(12)
    }
    
  end
end