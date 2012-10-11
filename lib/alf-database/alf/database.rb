require_relative 'database/options'
require_relative 'database/connection'
module Alf
  class Database
    include Options.helpers(:default_options)

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
      @adapter, @default_options = adapter, options.freeze
    end
    attr_reader :adapter, :default_options

    ### connection handling

    def connection(opts = {})
      Connection.new(self, default_options.merge(opts)) do |conn_opts|
        conn = adapter.connection
        conn = Adapter::Connection::SchemaCached.new(conn) if conn_opts.schema_cache?
        conn
      end
    end

    def connect(opts = {})
      c = connection(opts)
      yield(c)
    ensure
      c.close if c
    end

  end # class Database
end # module Alf
