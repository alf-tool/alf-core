require 'spec_helper'
module Alf
  describe Adapter, "autodetect" do

    let(:examples_path){ Path.backfind('examples/operators') }

    it "should recognize an existing folder" do
      db = Adapter.autodetect(File.dirname(__FILE__))
      db.should eq(Adapter::Folder)
    end

    it "should raise an Argument when no match" do
      lambda{ Adapter.autodetect(12) }.should raise_error(ArgumentError)
    end

  end
end
