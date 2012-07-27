require 'spec_helper'

require 'unit/alf-optimizer/shared/a_pass_through_expression_for_restrict'
require 'unit/alf-optimizer/shared/a_split_able_expression_for_restrict'
require 'unit/alf-optimizer/shared/an_unoptimizable_expression_for_restrict'
require 'unit/alf-optimizer/shared/an_optimizable_expression_for_restrict'

module Helpers

  def comp(*args)
    args.unshift(:eq) if args.first.is_a?(Hash)
    Alf::Predicate.comp(*args)
  end

end

RSpec.configure do |c|
  c.include Alf::Lang::Functional
end