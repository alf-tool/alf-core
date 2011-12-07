module Alf
  class Error < StandardError; end
  class NoSuchDatasetError < Error; end
  class CoercionError < Error; end
end
