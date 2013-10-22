require 'spec_helper'
module Alf
  describe Summarization, "summarize" do

    it 'should summarize as expected' do
      rel = [
        {:qty => 10, :size => 12},
        {:qty => 5,  :size => 5}
      ]
      sum = Summarization.coerce(["s", Aggregator.avg{ qty }, "m", Aggregator.max{ size }])
      sum.summarize(rel).should eq({:s => 7.5, :m => 12})
    end

  end
end
