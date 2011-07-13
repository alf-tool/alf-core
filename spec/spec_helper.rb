$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'alf'

Alf::Lispy.extend(Alf::Lispy)

def rel(*args)
  Alf::Relation.coerce(args)
end

require 'shared/an_operator_class'
require 'shared/a_value'