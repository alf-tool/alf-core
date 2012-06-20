require 'spec_helper'
require 'fileutils'
require "sequel"
module Alf
  describe Sequel::Database, "ping" do
    
    let(:path){ Path.dir/"../alf.db" }

    def uri
      protocol = defined?(JRUBY_VERSION) ? "jdbc:sqlite" : "sqlite"
      "#{protocol}://#{path.to_s}"
    end

    it "returns true on a file" do
      Sequel::Database.new(path.to_s).ping.should be_true
    end

    it "returns true on an uri" do
      Sequel::Database.new(uri).ping.should be_true
    end

    it "returns true on a Path" do
      Sequel::Database.new(path).ping.should be_true
    end

    it "raises on non existing" do
      lambda {
        Sequel::Database.new("postgres://non-existing.sqlite3").ping
      }.should raise_error
    end

  end
end
