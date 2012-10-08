module Alf
  module Algebra
    module Operand
      class Proxy
        include Operand

        def initialize(subject)
          @subject = subject
        end
        attr_reader :subject

        def to_cog
          return subject.to_cog if subject.respond_to?(:to_cog)
          Alf::Engine::Leaf.new(subject)
        end

        def to_relvar
          return subject.to_relvar if subject.respond_to?(:to_relvar)
          super
        end

      end # class Proxy
    end # module Operand
  end # module Algebra
end # module Alf
