module Alf
  module Tools

    # Myrrha rules for converting to ruby literals
    ToRubyLiteral = Myrrha::ToRubyLiteral.dup.append do
    end
    
    # Delegated to ToRubyLiteral
    def to_ruby_literal(value)
      ToRubyLiteral.apply(value)
    end
    
  end # module Tools
end # module Alf