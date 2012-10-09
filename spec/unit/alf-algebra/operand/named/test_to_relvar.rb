require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Named, "to_relvar" do

        let(:operand){ Named.new(:foo).bind(self) }

        subject{ operand.to_relvar }

        it 'returns a base relvar' do
          subject.should be_a(Relvar::Base)
        end

      end
    end
  end
end
