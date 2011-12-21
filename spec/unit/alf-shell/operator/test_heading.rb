require 'spec_helper'
module Alf::Shell::Operator
  describe Heading do

    let(:input){ [] }
    subject{ Heading.run(argv) }

    context "the default config" do
      let(:argv){ [input] }
      specify{
        subject.should be_a(Alf::Operator::Relational::Heading)
      }
    end

  end
end
