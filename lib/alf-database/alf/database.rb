require_relative 'database/options'
require_relative 'database/connection'
module Alf
  class Database
    include Options

    def self.new(conn_spec, options = {})
      db = super(Adapter.factor(conn_spec), options)
      yield(db) if block_given?
      db
    end

    def self.connect(conn_spec, options = {}, &bl)
      db = new(conn_spec, options)
      bl ? db.connect(&bl) : db.connection
    end

    def initialize(adapter, options = {})
      @adapter = adapter
      install_options_from_hash(options)
    end
    attr_reader :adapter, :options

    ### connection handling

    def adapter_connection
      conn = adapter.connection
      conn = Adapter::Connection::SchemaCached.new(conn) if schema_cache?
      conn
    end

    def connection
      Connection.new(self)
    end

    def connect
      c = connection
      yield(c)
    ensure
      c.close if c
    end

  end # class Database
end # module Alf
