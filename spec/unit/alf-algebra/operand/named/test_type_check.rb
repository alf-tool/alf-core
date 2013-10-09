require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Named, "type_check" do

        subject{ operand.type_check }

        def knows?(name)
          name == :foo
        end

        def heading(name)
          :"#{name}_heading"
        end

        context 'when known' do
          let(:operand){ Named.new(:foo, self) }

          it 'returns the heading' do
            subject.should eq(:foo_heading)
          end
        end

        context 'when unknown' do
          let(:operand){ Named.new(:bar, self) }

          it 'raises a TypeCheckError' do
            lambda{
              subject
            }.should raise_error(TypeCheckError, /No such relvar `bar`/)
          end
        end

      end
    end
  end
end
