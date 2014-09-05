module Alf
  class Adapter
    class Memory
      class Connection < Adapter::Connection

        def initialize(*args, &bl)
          super
          @relvars = {}
        end

        # Returns true if `name` is known, false otherwise.
        def knows?(name)
          true
        end

        # Returns a cog for `expr` inside the compilation plan `plan`
        def cog(plan, expr)
          _relvar(expr.name).to_cog
        end

        # Inserts `tuples` in the relvar called `name`
        def insert(name, *args, &bl)
          _relvar(name).insert(*args, &bl)
        end

        # Delete from the relvar called `name`
        def delete(name, *args, &bl)
          _relvar(name).delete(*args, &bl)
        end

        # Updates the relvar called `name`
        def update(name, *args, &bl)
          _relvar(name).update(*args, &bl)
        end

      private

        def _relvar(name)
          @relvars[name] ||= Relvar::Memory.new(DUM)
        end

      end # class Connection
    end # class Memory
  end # class Adapter
end # module Alf
