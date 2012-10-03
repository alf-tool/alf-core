module Alf
  module Algebra
    module Operand
      class Proxy
        include Operand

        def initialize(subject)
          @subject = subject
        end

      end # class Proxy
    end # module Operand
  end # module Algebra
end # module Alf
