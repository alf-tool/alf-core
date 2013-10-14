require 'spec_helper'
module Alf
  module Lang
    module Parser
      describe Safer, "test_parse" do

        let(:viewpoint) do
          Module.new{
            def suppliers
              Algebra::Operand::Named.new(:suppliers)
            end
          }
        end

        let(:parser){ Safer.new([viewpoint]) }

        context 'with a ruby block' do
          subject{ parser.parse{} }

          it 'raises a SecurityError' do
            lambda{
              subject
            }.should raise_error(SecurityError, /Parsing of ruby blocks forbidden/)
          end
        end

        context 'with a symbol' do
          let(:op){ Algebra::Operand::Named.new(:suppliers) }
          subject{ parser.parse(:suppliers) }

          it 'passes and returns the operand' do
            subject.should eq(op)
          end
        end

        context 'with an operand' do
          let(:op){ Algebra::Operand::Named.new(:suppliers) }
          subject{ parser.parse(op) }

          it 'returns it immediately' do
            subject.should be(op)
          end
        end

        context 'with an attempt attack based on a symbol' do
          subject{ parser.parse(:"send(:suppliers)") }

          it 'fails with a security error' do
            lambda{
              subject
            }.should raise_error(SecurityError, /Forbidden/)
          end
        end

        (Path.dir/'safe.txt').each_line do |line|
          context "on '#{line.strip}'" do
            subject{ parser.parse(line.strip) }

            it 'succeeds' do
              lambda{
                subject
              }.should_not raise_error
            end
          end
        end

        (Path.dir/'unsafe.txt').each_line do |line|
          context "on '#{line.strip}'" do
            subject{ parser.parse(line.strip) }

            it 'raises a SecurityError' do
              lambda{
                subject
              }.should raise_error(SecurityError, /Forbidden/)
            end
          end
        end

      end
    end
  end
end
