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
      @adapter, @default_options = adapter, options.freeze
    end
    attr_reader :adapter, :default_options

    def_delegators :default_options, *Options.delegation_methods

    ### connection handling

    def connection(opts = {})
      Connection.new(self, default_options.merge(opts))
    end

    def connect(opts = {})
      c = connection(opts)
      yield(c)
    ensure
      c.close if c
    end

  end # class Database
end # module Alf
