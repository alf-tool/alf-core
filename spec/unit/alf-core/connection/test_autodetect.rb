require 'spec_helper'
module Alf
  describe Connection, "autodetect" do

    let(:examples_path){ Path.backfind('examples/operators') }

    it "should recognize an existing folder" do
      db = Connection.autodetect(File.dirname(__FILE__))
      db.should eq(Connection::Folder)
    end

    it "should raise an Argument when no match" do
      lambda{ Connection.autodetect(12) }.should raise_error(ArgumentError)
    end

  end
end
