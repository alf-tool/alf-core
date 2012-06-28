require File.expand_path('../../sequel_helper', __FILE__)
module Alf
  module Sequel
    describe Adapter, "recognizes?" do
      include TestHelper

      it "recognizes sqlite files" do
        Adapter.recognizes?(["#{sequel_database_path}"]).should be_true
      end

      it "recognizes a Path to a sqlite databases" do
        Adapter.recognizes?([sequel_database_path]).should be_true
      end

      it "recognizes database uris" do
        Adapter.recognizes?(["postgres://localhost/database"]).should be_true
        Adapter.recognizes?([sequel_database_uri]).should be_true
      end

      it "recognizes a Hash ala Rails" do
        config = {"adapter" => "sqlite", "database" => "#{sequel_database_path}"}
        Adapter.recognizes?([config]).should be_true
        Adapter.recognizes?([Tools.symbolize_keys(config)]).should be_true
      end

      it "should not be too permissive" do
        Adapter.recognizes?(["nosuchone.db"]).should be_false
        Adapter.recognizes?([nil]).should be_false
      end

      it "should let Adapter autodetect sqlite files" do
        Alf::Adapter.autodetect(sequel_database_path).should be_a(Adapter)
        Alf::Adapter.autodetect("#{sequel_database_path}").should be_a(Adapter)
      end

    end
  end
end
