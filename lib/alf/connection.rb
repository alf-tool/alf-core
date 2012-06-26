require_relative 'context/external'
require_relative 'context/internal'
module Alf
  class Connection
    include Context::Internal
    include Context::External

  private

    def context
      self
    end

  end # class Connection
end # module Alf