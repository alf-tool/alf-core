require 'spec_helper'
module Alf::Shell::Operator
  describe Clip do

    let(:input){ suppliers }
    subject{ Clip.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Clip)
      subject.attributes.should eq(Alf::AttrList[:a, :b])
      subject.operands.should eq([input])
    end

    context "--no-allbut" do
      let(:argv){ [input, "--", "a", "b"] }
      specify{
        subject.allbut.should be_false
      }
    end

    context "--allbut" do
      let(:argv){ [input, "--allbut", "--", "a", "b"] }
      specify{
        subject.allbut.should be_true
      }
    end

  end
end
