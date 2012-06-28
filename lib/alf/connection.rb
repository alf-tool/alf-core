require_relative 'context/external'
require_relative 'context/internal'
module Alf
  class Connection
    include Context::Internal
    include Context::External

    # Logical adapter
    attr_reader :adapter

    # Creates a database instance, using `adapter` as logical
    # adapter.
    def initialize(adapter = nil, helpers = [])
      super()
      @adapter = adapter
      @helpers = helpers
    end

  private

    def context
      self
    end

  end # class Connection
end # module Alf