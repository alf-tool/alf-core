require 'spec_helper'
module Alf
  describe TuplePredicate do

    describe "the class itself" do
      let(:type){ TuplePredicate }
      def TuplePredicate.exemplars
        [
          "status > 10",
          {:status => 10}
        ].map{|x| TuplePredicate.coerce(x)}
      end
      it_should_behave_like 'A valid type implementation'
    end

    let(:handle){ Tools::TupleHandle.new.set(:status => 10) }

    describe "coerce" do

      subject{ TuplePredicate.coerce(arg).evaluate(handle) }

      describe "from TuplePredicate" do
        let(:arg){ TuplePredicate.new(lambda{ status == 10 }) }
        it{ should eql(true) }
      end

      describe "from true" do
        let(:arg){ true }
        it{ should eql(true) }
      end

      describe "from false" do
        let(:arg){ false }
        it{ should eql(false) }
      end

      describe "from Proc" do
        let(:arg){ lambda{ status == 10 } }
        it{ should eql(true) }
      end

      describe "from String" do
        let(:arg){ "status == 10" }
        it{ should eql(true) }
      end

      describe "from Symbol" do
        let(:arg){ :status }
        it{ should eql(10) }
      end

      describe "from Hash without coercion" do
        let(:arg){ {:status => 10} }
        it{ should eql(true) }
      end

      describe "from Hash with coercion" do
        let(:arg){ {"status" => "10"} }
        it{ should eql(true) }
      end

      describe "from a singleton Array" do
        let(:arg){ ["status == 10"] }
        it{ should eql(true) }
      end

      describe "from an Array with coercion" do
        let(:arg){ ["status", "10"] }
        it{ should eql(true) }
      end

    end # coerce

    describe "from_argv" do

      subject{ TuplePredicate.from_argv(argv).evaluate(handle) }
      
      describe "from a singleton Array" do
        let(:argv){ ["status == 10"] }
        it{ should eql(true) }
      end

      describe "from an Array with coercion" do
        let(:argv){ ["status", "10"] }
        it{ should eql(true) }
      end

    end # from_argv

  end # TuplePredicate
end # Alf
