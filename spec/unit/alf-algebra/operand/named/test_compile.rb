require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Named, "compile" do

        let(:operand){ Named.new(:foo).bind(self) }

        subject{ operand.compile }

        def cog(name)
          [:a_cog, name]
        end

        it 'delegates to the underlying connection when bound' do
          subject.should eq([:a_cog, :foo])
        end

      end
    end
  end
end
