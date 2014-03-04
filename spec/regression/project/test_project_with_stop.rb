require 'spec_helper'
module Alf
  describe "project(...)" do

    subject{
      Alf.examples.query do
        project(matching(supplies, restrict(suppliers, city: "Paris")), [:pid])
      end
    }

    it "should not raise an error" do
      ->{
        subject
      }.should_not raise_error
    end

  end
end
