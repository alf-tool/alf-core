require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Named, "to_cog" do

        let(:operand){ Named.new(:foo).bind(self) }

        subject{ operand.to_cog }

        def cog(name, expr)
          expr.should be(operand)
          [:a_cog, name]
        end

        it 'delegates to the underlying connection when bound' do
          subject.should eq([:a_cog, :foo])
        end

      end
    end
  end
end
