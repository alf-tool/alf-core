module Alf
  class Predicate
    module Native
      include Expr

      def priority
        90
      end

      def proc
        self[1]
      end

      def to_ruby_code(scope = 't')
        if proc.respond_to?(:source_code)
          code = proc.source_code
          return code if code
        end
        raise NotSupportedError
      end

      def to_proc(scope = 't')
        proc
      end

      def free_variables
        raise NotSupportedError
      end

    end
  end
end
