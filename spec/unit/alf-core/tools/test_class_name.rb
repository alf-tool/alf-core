require 'spec_helper'
module Alf
  describe Tools, "class_name" do

    let(:tools){ Object.new.extend(Tools) }

    it "should work on top-level namespaces" do
      tools.class_name(Alf).should eq(:Alf)
    end

    it "should work on non top-level namespaces" do
      tools.class_name(Alf::Tools).should eq(:Tools)
    end

  end
end
