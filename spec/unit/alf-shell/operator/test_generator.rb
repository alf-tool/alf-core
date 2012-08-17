require 'spec_helper'
module Alf::Shell::Operator
  describe Generator do

    subject{ Generator.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Generator)
      subject.operands.should eq([])
    end

    context "with empty args" do
      let(:argv){ %w{} }
      specify{
        subject.size.should eq(10)
        subject.as.should eq(:num)
      }
    end

    context "with a size" do
      let(:argv){ %w{-- 2} }
      specify{
        subject.size.should eq(2)
        subject.as.should eq(:num)
      }
    end

    context "with a size and a name" do
      let(:argv){ %w{-- 2 -- generated} }
      specify{
        subject.size.should eq(2)
        subject.as.should eq(:generated)
      }
    end

  end
end
