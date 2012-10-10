require_relative 'database/options'
require_relative 'database/connection'
module Alf
  class Database

    DEFAULT_OPTIONS = { cache_schema: true }

    def self.connect(conn_spec, &bl)
      adapter = Adapter.factor(conn_spec)
      if bl
        Database.new(adapter).connect(&bl)
      else
        Database.new(adapter).connection
      end
    end

    def initialize(adapter, options = {})
      @adapter = adapter
      @options = DEFAULT_OPTIONS.merge(options)
    end
    attr_reader :adapter, :options

    ### options

    def schema_cached?
      options[:cache_schema]
    end

    ### connection handling

    def connection
      Connection.new(self, adapter_connection)
    end

    def connect
      c = connection
      yield(c)
    ensure
      c.close if c
    end

  private

    def adapter_connection
      conn = adapter.connection
      conn = Adapter::Connection::SchemaCached.new(conn) if schema_cached?
      conn
    end

  end # class Database
end # module Alf
