module Alf
  module Algebra
    module Operand
      class Named
        include Operand

        def initialize(name, connection = nil)
          @name = name
          @connection = connection
        end
        attr_reader :name

        ### Operand

        def keys
          connection!.keys(name)
        end

        def heading
          connection!.heading(name)
        end

        ### Compilation and update

        def to_cog
          connection!.cog(name)
        end

        def to_relvar
          Relvar::Base.new connection, name
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
