module Alf
  module Algebra
    module Operand
      class Named
        include Operand::Leaf

        def initialize(connection, name)
          @connection = connection
          @name = name
        end
        attr_reader :connection, :name

        ### Operand

        def keys
          connection.keys(name)
        end

        def heading
          connection.heading(name)
        end

        ### Compilation and update

        def to_cog
          connection.cog(name)
        end

        def to_relvar
          connection.relvar(name)
        end

        ### Readable output

        def to_s
          "Operand::Named(#{name.inspect})"
        end

        def to_lispy
          name.to_s
        end

      end # Named
    end # module Operand
  end # module Algebra
end # module Alf
