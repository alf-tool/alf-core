require 'spec_helper'
module Alf
  class Predicate
    describe ProcParser, "parse" do

      let(:scope){ Tools::TupleScope.new(:id => 12, :name => "foo") }

      let(:parser){ ProcParser.new(scope) }

      subject{ parser.parse(proc) }

      context 'on a single attribute name' do
        let(:proc){ lambda{ id } }

        it{ should eq([:_var_ref, :id]) }
      end

      context 'on a single name that is not an attribute' do
        let(:proc){ lambda{ now } }
      
        it{ should eq([:now]) }
      end

      [ :==, 
        :<, 
        :>, 
        :<=, 
        :>=, 
        :!=, 
        :=~,
        :&,
        :| ].each do |m|

        context "on #{m} with a constant" do
          let(:proc){ Kernel.eval "lambda{ id #{m} 1 }" }

          it{ should eq([m, [:_var_ref, :id], [:_literal, 1]]) }
        end

        context "on #{m} with another attribute" do
          let(:proc){ Kernel.eval "lambda{ id #{m} name }" }

          it{ should eq([m, [:_var_ref, :id], [:_var_ref, :name]]) }
        end

      end

      if RUBY_VERSION >= "1.9"
        context "on ! with an attribute" do
          let(:proc){ lambda{ !id } }

          it{ should eq([:!, [:_var_ref, :id]]) }
        end
      end

    end
  end
end