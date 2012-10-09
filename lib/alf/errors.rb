module Alf
  class Error < StandardError; end
  class UnboundError < StandardError; end
  class NotSupportedError < Error; end
  class NoSuchSchemaError < Error; end
  class NoSuchRelvarError < Error; end
  class NoSuchTupleError < Error; end
  class FactAssertionError < Error; end
  class CoercionError < Error; end
end
