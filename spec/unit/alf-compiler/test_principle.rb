require 'compiler_helper'
module Alf
  describe Compiler, "the overall principle" do

    # This is a compiler dedicated to specific adapters, e.g. SQL
    class DedicatedCompiler < Compiler

      def on_project(expr, compiled)
        DedicatedCog.new(expr, self, [compiled])
      end

      def on_unwrap(expr, compiled, &fallback)
        fallback.call
      end

      def on_union(expr, left, right, &fallback)
        DedicatedCog.new(expr, self, [left, right])
      end

    end # class DedicatedCompiler

    # This is the class supposed to be served by an adapter.
    # It returns self on to_cog and has the dedicated compiler.
    class DedicatedCog
      include Engine::Cog

      def initialize(expr, compiler, operands = nil)
        super(expr, compiler)
        @operands = operands
      end
      attr_reader :operands

      def operand
        unless operands && operands.size == 1
          raise "Unexpected operands `#{operands.inspect}`"
        end
        operands.first
      end

    end # class DedicatedCog

    subject{ default.call(expr) }

    let(:cog){
      DedicatedCog.new(nil, dedicated)
    }

    let(:cog2){
      DedicatedCog.new(nil, dedicated)
    }

    let(:default){
      Compiler::Default.new
    }

    let(:dedicated){
      DedicatedCompiler.new
    }

    context 'on a direct cog-proxied operand' do
      # the first compiler takes care of compiling the stuff, by simple
      # delegation to to_cog of the operand
      
      let(:expr){
        an_operand(cog)
      }

      it{ should be(cog) }

      it 'should have expected compiler' do
        subject.compiler.should be(dedicated)
      end
    end

    context 'on a supported operator' do
      # the first compiler compiles the leaf.
      # the second compiler compiles the projection.

      let(:expr){
        project(an_operand(cog), [:a])
      }

      it{ should be_a(DedicatedCog) }

      it 'should have correct expr' do
        subject.expr.should be(expr)
      end

      it 'should have expected compiler' do
        subject.compiler.should be(dedicated)
      end

      it 'should have correct operand' do
        subject.operand.should be(cog)
        subject.operand.compiler.should be(dedicated)
      end
    end

    context 'on a dyadic supported operator' do
      # the first compiler compiles both leafs.
      # the second compiler compiles the union.

      let(:expr){
        union(an_operand(cog), an_operand(cog2))
      }

      it{ should be_a(DedicatedCog) }

      it 'should have correct expr' do
        subject.expr.should be(expr)
      end

      it 'should have correct operands' do
        subject.operands.should eq([cog, cog2])
      end

      it 'should have expected compiler' do
        subject.compiler.should be(dedicated)
      end
    end

    context 'on an unsupported operator' do
      # the first compiler compiles the leaf.
      # the second compiler fails at compiling the projection.
      # the first compiler compiles the projection.

      let(:expr){
        rename(an_operand(cog), :a => :b)
      }

      it{ should be_a(Engine::Rename) }

      it 'should have the cog as operand' do
        subject.operand.should be(cog)
      end

      it 'should have expected compiler' do
        subject.compiler.should be(default)
      end
    end

    context 'on a partly supported operator' do
      # the first compiler compiles the leaf.
      # the second compiler fails at compiling the unwrap and fallsback.
      # the first compiler compiles the unwrap.

      let(:expr){
        unwrap(an_operand(cog), :a)
      }

      it{ should be_a(Engine::Unwrap) }

      it 'should have the cog as operand' do
        subject.operand.should be(cog)
      end

      it 'should have expected compilers' do
        subject.compiler.should be(default)
      end
    end

    context 'on a doubly supported operator' do
      # the first compiler compiles the leaf.
      # the second compiler compiles the first projection.
      # the second compiler compiles the second projection.

      let(:subexpr){
        project(an_operand(cog), [:a])
      }

      let(:expr){
        project(subexpr)
      }

      it{ should be_a(DedicatedCog) }

      it 'should have correct traceability' do
        subject.expr.should be(expr)
      end

      it 'should have expected compiler' do
        subject.compiler.should be(dedicated)
      end

      it 'should have correct sub-cog' do
        subject.operand.should be_a(DedicatedCog)
        subject.operand.expr.should be(subexpr)
        subject.operand.compiler.should be(dedicated)
      end

      it 'should have correct sub-sub-cog' do
        subject.operand.operand.should be(cog)
        subject.operand.operand.compiler.should be(dedicated)
      end
    end
  end
end
