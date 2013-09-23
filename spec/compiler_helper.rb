require 'spec_helper'

require_relative 'unit/alf-compiler/shared/a_cog_adding_a_sub_sort'
require_relative 'unit/alf-compiler/shared/a_cog_adding_a_reversed_sort'
require_relative 'unit/alf-compiler/shared/a_cog_reusing_a_sub_sort'
require_relative 'unit/alf-compiler/shared/a_cog_not_reusing_a_sub_sort'

module CompilerHelper

  def leaf
    @leaf ||= Alf::Engine::Leaf.new([{a: 2}, {a: 1}], Alf::Algebra::Operand::Named.new(:leaf))
  end

end

RSpec.configure do |c|
  c.include Alf::Lang::Functional
  c.include CompilerHelper
end
