require 'spec_helper'
module Alf::Shell::Operator
  describe Project do

    let(:input){ suppliers }
    subject{ Project.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Project)
      subject.operands.should eq([input])
    end

    context "--no-allbut" do
      let(:argv){ [input, "--", "a", "b"] }
      specify{
        subject.attributes.should eq(Alf::AttrList[:a, :b])
        subject.allbut.should eq(false)
      }
    end

    context "--allbut" do
      let(:argv){ [input, "--allbut", "--", "a", "b"] }
      specify{
        subject.attributes.should eq(Alf::AttrList[:a, :b])
        subject.allbut.should eq(true)
      }
    end

    context "none projected" do
      let(:argv){ [input] }
      specify{
        subject.attributes.should eq(Alf::AttrList[])
        subject.allbut.should eq(false)
      }
    end

  end
end
