require 'spec_helper'
module Alf
  describe Support, "rubycase_name" do

    let(:tools){ Object.new.extend(Support) }

    it "should work on a Symbol" do
      tools.rubycase_name(:Alf).should == :alf
    end

    it "should work on a String" do
      tools.rubycase_name("HelloWorld").should == :hello_world
    end

    it "should work on a Class" do
      tools.rubycase_name(String ).should == :string
    end

    it "should work on a Module" do
      tools.rubycase_name(Algebra::NonRelational).should == :non_relational
    end

  end
end
