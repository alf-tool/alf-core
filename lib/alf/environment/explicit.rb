module Alf
  class Environment
    #
    # Specialization of Environment that works with explicitely defined 
    # datasources and allow branching and unbranching.
    #
    class Explicit < Environment
      
      #
      # Creates a new environment instance with initial definitions
      # and optional child environment.
      #
      def initialize(defs = {}, child = nil)
        @defs = defs
        @child = child
      end
      
      # 
      # Unbranches this environment and returns its child
      #
      def unbranch
        @child
      end
      
      # (see Environment#dataset)
      def dataset(name)
        if @defs.has_key?(name)
          @defs[name]
        elsif @child
          @child.dataset(name)
        else
          raise "No such dataset #{name}"
        end 
      end
      
    end # class Explicit
  end # class Environment
end # module Alf