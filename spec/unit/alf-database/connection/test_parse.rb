require 'spec_helper'
module Alf
  class Database
    describe Connection, "parse" do

      let(:conn){ sap_conn }

      shared_examples_for 'a bound expression' do

        it{ should be_bound }
        
        it 'has the expected connection' do
          subject.connection!.should be(conn)
        end

        it 'has bound operands too' do
          subject.operands.all?{|op|
            op.should be_bound
            op.connection!.should be(conn)
          } if subject.is_a?(Algebra::Operator)
        end
      end

      shared_examples_for 'a named operand on suppliers' do

        it_should_behave_like 'a bound expression'
        
        it{ should be_a(Algebra::Operand::Named) }

        it 'has the expected name' do
          subject.name.should eq(:suppliers)
        end
      end

      shared_examples_for 'a join operand on suppliers and supplies' do

        it_should_behave_like 'a bound expression'
        
        it{ should be_a(Algebra::Join) }
      end

      context 'when a single leaf operand' do

        context 'parsed from a Symbol' do
          subject{ conn.parse(:suppliers) }

          it_should_behave_like 'a named operand on suppliers'
        end

        context 'parsed from a String' do
          subject{ conn.parse('suppliers') }

          it_should_behave_like 'a named operand on suppliers'
        end

        context 'parsed from a Proc' do
          subject{ conn.parse{ suppliers } }

          it_should_behave_like 'a named operand on suppliers'
        end

        context 'parsed from an existing operand' do
          let(:expr){ Algebra.named_operand(:suppliers, 12) }

          subject{ conn.parse(expr) }

          it_should_behave_like 'a named operand on suppliers'

          it 'does not touch the original expr' do
            subject.should_not be(expr)
            expr.connection.should eq(12)
          end
        end
      end

      context 'when a complex expression' do

        context 'with a String' do
          subject{ conn.parse('join(project(suppliers, [:sid]), supplies)') }

          it_should_behave_like 'a join operand on suppliers and supplies'
        end

        context 'with a Proc' do
          subject{ conn.parse{ join(project(suppliers, [:sid]), supplies) } }

          it_should_behave_like 'a join operand on suppliers and supplies'
        end

        context 'with an expression' do
          let(:expr){
            conn.parse{ join(project(suppliers, [:sid]), supplies) }.bind(12)
          }

          subject{ conn.parse(expr) }

          it_should_behave_like 'a join operand on suppliers and supplies'

          it 'does not touch the original expr' do
            subject.should_not be(expr)
            expr.connection.should eq(12)
            expr.operands.all?{|op| op.connection.should eq(12) }
          end
        end
      end

    end
  end
end
