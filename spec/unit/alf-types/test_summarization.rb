require 'spec_helper'
module Alf
  describe Summarization do

    describe "the class itself" do
      let(:type){ Summarization }
      def Summarization.exemplars
        [
          ["total", Aggregator.sum{ qty }]
        ].map{|x| Summarization.coerce(x)}
      end
      it_should_behave_like 'A valid type implementation'
    end

    specify "least -> happens -> finalize" do
      scope = Support::TupleScope.new
      summ = Summarization.coerce(["s", Aggregator.sum{ qty }, "m", Aggregator.max{ size }])
      (x = summ.least).should eql(:s => 0, :m => nil)
      (x = summ.happens(x, scope.__set_tuple(:qty => 10, :size => 12))).should eq(:s => 10, :m => 12)
      (x = summ.happens(x, scope.__set_tuple(:qty => 5, :size => 5))).should eq(:s => 15, :m => 12)
      summ.finalize(x).should eq(:s => 15, :m => 12)
    end

  end
end
