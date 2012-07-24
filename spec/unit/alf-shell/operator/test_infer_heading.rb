require 'spec_helper'
module Alf::Shell::Operator
  describe InferHeading do

    let(:input){ [] }
    subject{ InferHeading.run(argv) }

    context "the default config" do
      let(:argv){ [input] }
      specify{
        subject.should be_a(Alf::Operator::Relational::InferHeading)
      }
    end

  end
end
