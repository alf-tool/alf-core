require 'spec_helper'
module Alf
  module Algebra
    describe Signature, "#argv2args" do
      
      class FakeOp
        attr_accessor :operands
      end
      before{ 
        signature.install
      }
      subject{
        signature.argv2args(argv)
      }
 
      context "on a signature with arguments only" do
        let(:signature){ 
          Signature.new(FakeOp) do |s|
            s.argument :proj, AttrList
          end
        }
        let(:argv){ %w{operand -- hello world} }

        it 'should return the expected triple' do
          [["operand"], [AttrList[:hello, :world]], {}]
        end
      end # arguments only

      context "with default values for arguments" do
        let(:signature){ 
          Signature.new(FakeOp) do |s|
            s.argument :attrname, AttrName, :autonum
          end
        }
        let(:arguments){ subject[1] }

        context 'and passed' do
          let(:argv){ %w{operand -- hello} }

          it 'should not use the default value' do
            arguments.should eq([:hello]) 
          end
        end

        context 'and not passed' do
          let(:argv){ %w{operand} }

          it 'should use the default value' do
            arguments.should eq([:autonum]) 
          end
        end
      end # default values for arguments

      context "on a signature with options" do
        let(:signature){
          Signature.new(FakeOp) do |s|
            s.argument :key, AttrList, []
            s.option   :allbut, Boolean, false
          end
        }
        let(:options){ subject[2] }

        context "when no option is provided" do
          let(:argv){ %w{operand -- hello world} }

          it 'should use the default values for options' do
            options.should eq({:allbut => false})
          end
        end

        context "when option is provided" do
          let(:argv){ %w{operand --allbut -- hello world} }

          it 'should not use the default values for options' do
            options.should eq({:allbut => true})
          end
        end
      end # signature with options

    end
  end
end
