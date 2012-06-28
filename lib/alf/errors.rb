module Alf
  class Error < StandardError; end
  class NoSuchRelvarError < Error; end
  class NoSuchTupleError < Error; end
  class CoercionError < Error; end
end
