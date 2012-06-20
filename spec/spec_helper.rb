$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alf'
require "rspec"
require 'epath'

Alf::Lispy.extend(Alf::Lispy)

def _(path, file)
  File.expand_path("../#{path}", file)
end

def wlang(str, binding)
  str.gsub(/\$\(([\S]+)\)/){ Kernel.eval($1, binding) }
end

require 'shared/an_operator_class'
require 'shared/a_valid_type_implementation'
require 'shared/a_value'

RSpec.configure do |c|
  c.filter_run_excluding :ruby19 => (RUBY_VERSION < "1.9")
end
