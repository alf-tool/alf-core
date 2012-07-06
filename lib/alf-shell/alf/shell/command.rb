module Alf
  module Command
    module ClassMethods

      # @return true
      def command?
        true
      end

      # @return false
      def operator?
        false
      end

    end # module ClassMethods
  end # module Command
end # module Alf
require_relative 'command/main'
require_relative 'command/exec'
require_relative 'command/help'
require_relative 'command/show'
