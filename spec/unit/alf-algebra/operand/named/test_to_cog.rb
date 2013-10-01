require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Named, "to_cog" do

        let(:operand){ Named.new(:foo, self) }

        subject{ operand.to_cog(12) }

        def cog(plan, expr)
          plan.should eq(12)
          expr.should be(operand)
          [:a_cog, expr.name]
        end

        it 'delegates to the underlying connection when bound' do
          subject.should eq([:a_cog, :foo])
        end

      end
    end
  end
end
