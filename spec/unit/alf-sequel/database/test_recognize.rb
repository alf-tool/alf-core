require 'spec_helper'
require 'fileutils'
require "sequel"
module Alf
  describe Sequel::Database, "recognizes?" do
    
    let(:path){ Path.dir/"../alf.db" }

    def uri
      protocol = defined?(JRUBY_VERSION) ? "jdbc:sqlite" : "sqlite"
      "#{protocol}://#{path.to_s}"
    end

    it "should recognize sqlite files" do
      Sequel::Database.recognizes?([path.to_s]).should be_true
    end

    it "should recognize a Path to a sqlite databases" do
      Sequel::Database.recognizes?([path]).should be_true
    end

    it "should recognize database uris" do
      Sequel::Database.recognizes?(["postgres://localhost/database"]).should be_true
      Sequel::Database.recognizes?([uri]).should be_true
    end

    it "should not be too permissive" do
      Sequel::Database.recognizes?(["nosuchone.db"]).should be_false
      Sequel::Database.recognizes?([nil]).should be_false
    end

    it "should let Database autodetect sqlite files" do
      Database.autodetect(path.to_s).should be_a(Sequel::Database)
    end

  end
end
