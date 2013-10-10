require_relative 'shared/a_predicate_ast_node'
module Alf
  class Predicate
    describe Factory, 'native' do
      include Factory

      subject{ native(proc) }

      context 'with a proc' do
        let(:proc){ ->{} }

        it_should_behave_like "a predicate AST node"

        it{ should be_a(Native) }

        it{ should eql([:native, proc]) }
      end

      context 'with a String' do
        let(:proc){ "x > 2" }

        it_should_behave_like "a predicate AST node"

        it{ should be_a(Native) }

        it 'should have correct ruby code' do
          subject.to_ruby_code.should eql("->{ x > 2 }")
        end

        it 'should have correct proc' do
          subject.to_proc.should be_a(Proc)
          subject.to_proc.arity.should eql(0)
        end
      end

    end
  end
end
