require 'spec_helper'
module Alf::Shell::Operator
  describe InferHeading do

    let(:input){ suppliers }
    subject{ InferHeading.run(argv) }

    context "the default config" do
      let(:argv){ [input] }
      specify{
        subject.should be_a(Alf::Algebra::InferHeading)
      }
    end

  end
end
