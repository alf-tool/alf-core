require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Named, "keys" do

        let(:operand){ Named.new(:foo, self) }

        subject{ operand.keys }

        def keys(name)
          [name]
        end

        it 'delegates to the underlying connection when bound' do
          subject.should eq([:foo])
        end

      end
    end
  end
end
