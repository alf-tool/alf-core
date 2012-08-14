require "quickl"
require "myrrha"
require "path"
require "sexpr"
if RUBY_VERSION < "1.9"
  require "backports"
  require "backports/basic_object"
end
