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

    def self.included(mod)
      mod.extend(ClassMethods)
    end
  end # module Command
end # module Alf

