require_relative 'database/options'
require_relative 'database/connection'
module Alf
  class Database
    extend Forwardable

    def self.new(conn_spec, options = {})
      adapter = Adapter.factor(conn_spec)
      options = Options.new(options)
      yield(options) if block_given?
      super(adapter, options)
    end

    def self.connect(conn_spec, options = {}, &bl)
      db = new(conn_spec, options)
      bl ? db.connect(&bl) : db.connection
    end

    def initialize(adapter, options)
      @adapter, @options = adapter, options.freeze
    end
    attr_reader :adapter, :options

    def_delegators :options, *Options.public_instance_methods(false)
                                     .reject{|m| m.to_s =~ /=$/ }

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
