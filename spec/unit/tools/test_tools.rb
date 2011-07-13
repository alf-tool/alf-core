require 'spec_helper'
module Alf
  describe Tools do
   
    let(:tools){ Object.new.extend(Tools) }
    
    specify "class_name" do
      tools.class_name(Alf).should == :Alf
      tools.class_name(Alf::Tools).should == :Tools
    end

    specify "ruby_case" do
      tools.ruby_case(:Alf).should == "alf"
      tools.ruby_case(:HelloWorld).should == "hello_world"
    end

    specify "coalesce" do
      tools.coalesce(1).should == 1
      tools.coalesce(1, 2).should == 1
      tools.coalesce(1, nil).should == 1
      tools.coalesce(nil, 2).should == 2
    end
    
  end
end
