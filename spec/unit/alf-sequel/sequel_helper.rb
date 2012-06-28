require 'spec_helper'
require "sequel"
module Alf
  module Sequel
    module TestHelper

      def sequel_database_path
        Path.dir/'alf.db'
      end

      def sequel_database_uri
        "#{Sequel::Adapter.sqlite_protocol}://#{sequel_database_path}"
      end

      def sequel_adapter
        Sequel::Adapter.new(sequel_database_path)
      end

    end
  end
end