module Alf
  class Error < StandardError; end
  class ConfigError < Alf::Error; end
  class UnboundError < StandardError; end
  class NotSupportedError < Error; end
  class NoSuchRelvarError < Error; end
  class NoSuchTupleError < Error; end
  class FactAssertionError < Error; end
  class CoercionError < Error; end
  class ReadOnlyError < Error; end
  class TypeCheckError < Error; end
  class IllegalStateError < Error; end
  class SecurityError < Error; end

  # deprecated
  class UnsupportedError < Error; end
end
