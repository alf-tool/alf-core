require 'spec_helper'
module Alf
  class Database
    describe Connection, "parse" do

      let(:conn){ sap_conn }

      shared_examples_for 'a named operand on suppliers' do

        it{ should be_a(Algebra::Operand::Named) }

        it 'has the expected name' do
          subject.name.should eq(:suppliers)
        end
      end

      shared_examples_for 'a join operand on suppliers and supplies' do

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
      end

    end
  end
end
