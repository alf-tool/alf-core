require 'spec_helper'
module Alf::Shell::Operator
  describe Autonum do

    let(:input){ suppliers_var_ref }
    subject{ Autonum.run(argv) }

    before do
      subject.should be_a(Alf::Operator::NonRelational::Autonum)
      subject.operands.should eq([input])
    end

    context "with default attribute name" do
      let(:argv){ [input] }
      specify{
        subject.as.should eq(:autonum)
      }
    end

    context "with explicit attribute name" do
      let(:argv){ [input, "--", "unique"] }
      specify{
        subject.as.should eq(:unique)
      }
    end

  end
end
