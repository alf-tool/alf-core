require 'spec_helper'
module Alf
  module Lang
    module Parser
      describe Safer, "test_parse" do

        let(:parser){ Safer.new }

        context 'with a ruby block' do
          subject{ parser.parse{} }

          it 'raises a SecurityError' do
            lambda{
              subject
            }.should raise_error(SecurityError, /Parsing of ruby blocks forbidden/)
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
