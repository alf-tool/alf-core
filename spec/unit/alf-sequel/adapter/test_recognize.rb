require 'spec_helper'
require 'fileutils'
require "sequel"
module Alf
  describe Sequel::Adapter, "recognizes?" do

    let(:path){ Path.dir/"../alf.db" }

    def uri
      protocol = defined?(JRUBY_VERSION) ? "jdbc:sqlite" : "sqlite"
      "#{protocol}://#{path.to_s}"
    end

    it "recognizes sqlite files" do
      Sequel::Adapter.recognizes?([path.to_s]).should be_true
    end

    it "recognizes a Path to a sqlite databases" do
      Sequel::Adapter.recognizes?([path]).should be_true
    end

    it "recognizes database uris" do
      Sequel::Adapter.recognizes?(["postgres://localhost/database"]).should be_true
      Sequel::Adapter.recognizes?([uri]).should be_true
    end

    it "recognizes a Hash ala Rails" do
      config = {"adapter" => "sqlite", "database" => "#{path}"}
      Sequel::Adapter.recognizes?([config]).should be_true
      Sequel::Adapter.recognizes?([Tools.symbolize_keys(config)]).should be_true
    end

    it "should not be too permissive" do
      Sequel::Adapter.recognizes?(["nosuchone.db"]).should be_false
      Sequel::Adapter.recognizes?([nil]).should be_false
    end

    it "should let Adapter autodetect sqlite files" do
      Adapter.autodetect(path.to_s).should be_a(Sequel::Adapter)
    end

  end
end
