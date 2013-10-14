module Alf
  module Algebra
    module Operand
      class Proxy
        include Operand

        def initialize(subject)
          @subject = subject
        end
        attr_reader :subject

        def heading
          return subject.heading if subject.respond_to?(:heading)
          super
        end

        def keys
          return subject.keys if subject.respond_to?(:keys)
          super
        end

        def to_cog(*args, &bl)
          return subject.to_cog(*args, &bl) if subject.respond_to?(:to_cog)
          Alf::Engine::Leaf.new(subject)
        end

        def to_relvar
          return subject.to_relvar if subject.respond_to?(:to_relvar)
          super
        end

        def to_s
          subject.to_s
        end

        def inspect
          "Operand::Proxy(#{subject})"
        end

      end # class Proxy
    end # module Operand
  end # module Algebra
end # module Alf
