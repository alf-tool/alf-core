require 'spec_helper'
module Alf
  describe TupleComputation do

    describe "the class itself" do
      let(:type){ TupleComputation }
      def TupleComputation.exemplars
        [
          {:status => 10},
          {:big?   => "status > 10"}
        ].map{|x| TupleComputation.coerce(x)}
      end
      it_should_behave_like 'A valid type implementation'
    end

    it 'should have a valid example' do
      computation = TupleComputation[
        :big? => lambda{ status > 20 },
        :who  => lambda{ "#{first} #{last}" }
      ]
      res = computation.call(:last => "Jones", :first => "Bill", :status => 10)
      res.should eq(:big? => false, :who => "Bill Jones")
    end

    let(:scope){ Support::TupleScope.new(:who => "alf") }

  end
end
