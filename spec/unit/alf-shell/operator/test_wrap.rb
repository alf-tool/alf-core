require 'spec_helper'
module Alf::Shell::Operator
  describe Wrap do

    let(:input){ suppliers }
    subject{ Wrap.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Wrap)
      subject.operands.should eq([input])
    end

    context "without name" do
      let(:argv){ [input, "--", "a", "b"] }
      specify{
        subject.attributes.should eq(Alf::AttrList[:a, :b])
        subject.as.should eq(:wrapped)
      }
    end

    context "with a name" do
      let(:argv){ [input, "--", "a", "b", "--", "attrname"] }
      specify{
        subject.attributes.should eq(Alf::AttrList[:a, :b])
        subject.as.should eq(:attrname)
      }
    end

  end
end
