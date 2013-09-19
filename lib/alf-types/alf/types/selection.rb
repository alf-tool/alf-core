module Alf
  module Types
    class Selection
      extend Domain::Reuse.new(Array)

      coercions do |c|
        c.coercion(Array){|x,_|
          Selection.new(x.map{|y| Selector.coerce(y) })
        }
      end

      def select(tuple)
        reused_instance.map{|s| s.select(tuple) }
      end

    end # class Selection
  end # module Types
end # module Alf