module Alf
  module Algebra
    module Operand
      class Named
        include Operand

        def initialize(name, connection = nil)
          @name = name
          @connection = connection
        end
        attr_reader :name, :connection

        def connection!
          raise UnboundError, "Expression not bound `#{name}`" unless connection
          connection
        end

        def keys
          connection!.keys(name)
        end

        def heading
          connection!.heading(name)
        end

        def hash
          @hash ||= name.hash + 37*connection.hash
        end

        def ==(other)
          super || (other.is_a?(Named) &&
                    other.name==name   &&
                    other.connection == connection)
        end
        alias :eql? :==

        def to_cog(plan = nil)
          connection!.cog(plan, self)
        end

        def to_relvar
          Relvar::Base.new(self)
        end

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
