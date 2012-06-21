require 'spec_helper'
module Alf
  describe Adapter, "autodetect" do

    let(:examples_path){ Path.backfind('examples/operators') }

    it "should support an Adapter instance" do
      db = Adapter.folder(examples_path)
      Adapter.autodetect(db).should eq(db)
    end

    it "should recognize an existing folder" do
      db = Adapter.autodetect(File.dirname(__FILE__))
      db.should be_a(Adapter::Folder)
    end

    it "should raise an Argument when no match" do
      lambda{ Adapter.autodetect(12) }.should raise_error(ArgumentError)
    end

    it "should be aliased as coerce" do
      db = Adapter.folder(examples_path)
      Adapter.coerce(db).should eq(db)
      Adapter.coerce(File.dirname(__FILE__)).should be_a(Adapter::Folder)
    end

  end
end
