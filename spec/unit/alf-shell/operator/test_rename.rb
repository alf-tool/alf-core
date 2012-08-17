require 'spec_helper'
module Alf::Shell::Operator
  describe Rename do

    let(:input){ suppliers }
    subject{ Rename.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Rename)
      subject.operands.should eq([input])
    end

    context "a typical config" do
      let(:argv){ [input, '--', 'a', 'z'] }
      specify{
        subject.renaming.should eq(Alf::Renaming[:a => :z])
      }
    end

  end
end
