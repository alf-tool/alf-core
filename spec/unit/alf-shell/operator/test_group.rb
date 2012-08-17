require 'spec_helper'
module Alf::Shell::Operator
  describe Group do

    let(:input){ suppliers }
    subject{ Group.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Group)
      subject.operands.should eq([input])
    end

    context "--no-allbut" do
      let(:argv){ [input, "--", "time", "b", "--", "as"] }
      specify{
        subject.attributes.should eq(Alf::AttrList[:time, :b])
        subject.as.should eq(:as)
        subject.allbut.should eq(false)
      }
    end

    context "--allbut" do
      let(:argv){ [input, "--allbut", "--","a", "--", "as"] }
      specify{
        subject.attributes.should eq(Alf::AttrList[:a])
        subject.as.should eq(:as)
        subject.allbut.should eq(true)
      }
    end

  end
end
