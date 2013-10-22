require 'spec_helper'
module Alf
  describe TupleExpression do

    def TupleExpression.exemplars
      [
        ->{ 10 },
        ->(t){ t.status > 10 },
      ].map{|x| TupleExpression.coerce(x)}
    end

    let(:type){ TupleExpression }

    it_should_behave_like 'A valid type implementation'

  end # TupleExpression
end # Alf
