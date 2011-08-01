require 'spec_helper'
require 'date'
module Alf
  describe Relation do
  
    describe "when attributes on Date domain" do
      subject{ Relation[{:date => Date.today}] }
      it_should_behave_like "A value"
    end
    
  end
end
