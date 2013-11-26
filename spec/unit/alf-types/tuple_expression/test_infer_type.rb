require 'spec_helper'
module Alf
  describe TupleExpression, 'infer_type' do

    let(:expr){ TupleExpression.new(->(t){}, "", String) }

    subject{ expr.infer_type }

    it{ should be(String) }

  end # TupleExpression
end # Alf
