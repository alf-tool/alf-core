require 'spec_helper'
module Alf::Shell::Operator
  describe Summarize do

    let(:input){ suppliers }
    subject{ Summarize.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Summarize)
      subject.operands.should eq([input])
      subject.by.should eq(Alf::AttrList[:a])
      subject.summarization.should eq(Alf::Summarization[:time_sum => "sum{ time }"])
    end

    context "--no-allbut" do
      let(:argv){ [input] + ["--", "a", "--", "time_sum", "sum{ time }"] }
      specify{
        subject.allbut.should eq(false)
      }
    end

    context "--allbut" do
      let(:argv){ [input] + ["--allbut", "--", "a", "--", "time_sum", "sum{ time }"] }
      specify{
        subject.allbut.should eq(true)
      }
    end

  end
end
