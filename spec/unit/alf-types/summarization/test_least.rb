require 'spec_helper'
module Alf
  describe Summarization, "least" do

    it 'should invoke least on each aggregator' do
      sum = Summarization.coerce(["s", "avg{ qty }", "m", "max{ size }"])
      sum.least.should eq({:s => [0.0, 0.0], :m => nil})
    end

  end
end
