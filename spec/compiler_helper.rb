require 'spec_helper'

require 'unit/alf-engine/shared/a_compilable'

module CompilerHelper

  def resulting_cog
    subject.to_cog
  end

  def leaf
    @leaf ||= Alf::Engine::Leaf.new([{a: 2}, {a: 1}])
  end

end

RSpec.configure do |c|
  c.include Alf::Lang::Functional
  c.include CompilerHelper
end
