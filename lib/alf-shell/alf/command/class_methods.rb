module Alf
  module Command
    module ClassMethods

      #
      # Returns true
      #
      def command?
        true
      end
    
      #
      # Returns false
      #
      def operator?
        false
      end
    
    end

    def self.included(mod)
      mod.extend(ClassMethods)
    end

  end # module Command
end # module Alf

