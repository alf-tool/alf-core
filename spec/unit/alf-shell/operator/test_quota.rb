require 'spec_helper'
module Alf::Shell::Operator
  describe Quota do

    let(:input){ suppliers }
    subject{ Quota.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Quota)
      subject.operands.should eq([input])
    end

    context "a typical config" do
      let(:argv){ [input] + ["--", "a", "--", "time", "--", "time_sum", "sum{ time }"] }
      specify{
        subject.by.should eq(Alf::AttrList[:a])
        subject.order.should eq(Alf::Ordering[[:time, :asc]])
        subject.summarization.should eq(Alf::Summarization[:time_sum => "sum{ time }"])
      }
    end

  end
end
