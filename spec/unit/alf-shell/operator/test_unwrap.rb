require 'spec_helper'
module Alf::Shell::Operator
  describe Unwrap do

    let(:input){ suppliers }
    subject{ Unwrap.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Unwrap)
      subject.operands.should eq([input])
    end

    context "without name" do
      let(:argv){ [input] }
      specify{
        subject.attribute.should eq(:wrapped)
      }
    end

    context "with a name" do
      let(:argv){ [input] + %w{-- attrname} }
      specify{
        subject.attribute.should eq(:attrname)
      }
    end

  end
end
