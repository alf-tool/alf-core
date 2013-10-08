require_relative 'algebra/support'
require_relative 'algebra/operand'
require_relative 'algebra/operator'
require_relative 'algebra/shortcut'
module Alf
  module Algebra

    def named_operand(name, connection = nil)
      Operand::Named.new(name, connection)
    end
    module_function :named_operand

  end
end