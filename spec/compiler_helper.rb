require 'spec_helper'

require_relative 'unit/alf-compiler/shared/compiled_examples'

module CompilerHelper

  def compiler
    @compiler ||= Alf::Compiler::Default.new
  end

  def leaf
    @leaf ||= Alf::Engine::Leaf.new([{a: 2}, {a: 1}], Alf::Algebra::Operand::Named.new(:leaf))
  end

end

RSpec.configure do |c|
  c.include Alf::Lang::Functional
  c.include CompilerHelper
end
