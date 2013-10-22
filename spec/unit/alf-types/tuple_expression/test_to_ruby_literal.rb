require 'spec_helper'
module Alf
  describe TupleExpression, 'to_ruby_literal' do

    it 'should raise a NotImplementedError if no source code' do
      expr = TupleExpression[lambda{status > 10}]
      lambda{ expr.to_ruby_literal }.should raise_error(NotImplementedError)
    end

  end # TupleExpression
end # Alf
