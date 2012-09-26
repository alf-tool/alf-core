require 'spec_helper'
module Alf
  describe Renaming, "rename_tuple" do

    let(:r){ Renaming.coerce(["old", "new"]) } 

    it 'should rename correctly' do
      tuple    = {:old => :a, :other => :b}
      expected = {:new => :a, :other => :b}
      r.rename_tuple(tuple).should eq(expected)
    end

  end # Renaming
end # Alf
