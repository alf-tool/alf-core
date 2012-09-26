require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, Summarization)" do

    subject{ Shell.from_argv(argv, Summarization) }

    context "from an Array" do
      let(:argv){ ["s", "sum{ qty }", "m", "max{ size }"] }
      it{ should be_a(Summarization) }
      specify{ 
        ([:s, :m] & subject.aggregations.keys).should eq([:s, :m]) 
        subject.aggregations.values.all?{|v|
          v.is_a?(Aggregator)
        }.should be_true
      }
    end

  end
end
