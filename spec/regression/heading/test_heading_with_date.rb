require 'spec_helper'
require 'date'
module Alf
  describe Heading do
  
    describe "when attributes on Foo domain" do
      subject{ Heading[{:date => Date}] }
      it_should_behave_like "A value"
    end
    
  end
end
