require 'spec_helper'
module Alf
  describe Support, "ruby_case" do

    let(:tools){ Object.new.extend(Support) }

    it "should work on one word" do
      tools.ruby_case(:Alf).should == "alf"
    end

    it "should work on multiple words" do
      tools.ruby_case(:HelloWorld).should == "hello_world"
    end

  end
end
