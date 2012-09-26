require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, TupleComputation)" do

    subject{ Shell.from_argv(argv, TupleComputation) }

    describe "from an Array with coercions" do
      let(:argv){ ["hello", "who", "hello2", "2"] }
      let(:expected){
        TupleComputation.new(
          :hello => Alf::TupleExpression.coerce("who"), 
          :hello2 => Alf::TupleExpression.coerce("2"))
      }
      it{ should eql(expected) }
    end

  end
end
