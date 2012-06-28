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

      def sequel_database_memory
        "#{Sequel::Adapter.sqlite_protocol}:memory"
      end

      def sequel_adapter(arg = sequel_database_path)
        Sequel::Adapter.new(arg)
      end

      def sequel_names_adapter
        sequel_adapter(sequel_database_memory)
      end

      def create_names_schema(adapter, values = true)
        adapter.with_connection do |c|
          c.create_table(:names) do
            primary_key :id
            String :name
          end
          supplier_names_relation.each do |tuple|
            c[:names].insert(tuple)
          end if values
        end
        adapter.relvar(:names)
      end

    end
  end
end