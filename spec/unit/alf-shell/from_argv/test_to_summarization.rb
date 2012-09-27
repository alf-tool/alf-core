require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, Summarization)" do

    subject{ Shell.from_argv(argv, Summarization) }

    context "from an Array" do
      let(:argv){ ["s", "sum{ qty }", "m", "max{ size }"] }

      it{ should be_a(Summarization) }

      specify{
        subject.to_hash.keys.to_set.should eq([:s, :m].to_set)
        subject.to_hash.values.all?{|v| v.should be_a(Aggregator)}
      }
    end

  end
end
