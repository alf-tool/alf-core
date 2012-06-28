require File.expand_path('../../sequel_helper', __FILE__)
module Alf
  module Sequel
    describe Adapter, "ping" do
      include TestHelper

      it "returns true on a file" do
        Adapter.new("#{sequel_database_path}").ping.should be_true
      end

      it "returns true on an uri" do
        Adapter.new(sequel_database_uri).ping.should be_true
      end

      it "returns true on a Path" do
        Adapter.new(sequel_database_path).ping.should be_true
      end

      it "raises on non existing" do
        lambda {
          Adapter.new("postgres://non-existing.sqlite3").ping
        }.should raise_error
      end

    end
  end
end
