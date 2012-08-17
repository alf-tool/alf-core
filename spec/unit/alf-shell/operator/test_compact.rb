require 'spec_helper'
module Alf::Shell::Operator
  describe Compact do

    let(:input){ suppliers }
    subject{ Compact.run(argv) }

    context "the default config" do
      let(:argv){ [input] }
      specify{
        subject.should be_a(Alf::Algebra::Compact)
      }
    end

  end
end
