require 'spec_helper'
module Alf
  describe Database do

    describe "autodetect" do

      it "should support an Database instance" do
        db = Database.examples
        Database.autodetect(db).should eq(db)
      end

      it "should recognize an existing folder" do
        db = Database.autodetect(File.dirname(__FILE__))
        db.should be_a(Database::Folder)
      end

      it "should raise an Argument when no match" do
        lambda{ Database.autodetect(12) }.should raise_error(ArgumentError)
      end

      it "should be aliased as coerce" do
        db = Database.examples
        Database.coerce(db).should eq(db)
        Database.coerce(File.dirname(__FILE__)).should be_a(Database::Folder)
      end

    end # autodetect

  end
end
