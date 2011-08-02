require 'spec_helper'
module Alf
  module Tools
    describe Signature, '#to_shell_doc' do

      subject{ signature.to_shell_doc }

      describe "on an empty signature" do
        let(:signature){ Signature.new{|s|} }
        it{ should eq("OPERANDS") }
      end

      describe "on an option-only signature" do
        let(:signature){ 
          Signature.new do |s|
            s.option :allbut, Boolean
          end
        }
        it{ should eq("[--allbut] OPERANDS") }
      end

      describe "on an option-only signature with multiple options" do
        let(:signature){ 
          Signature.new do |s|
            s.option :allbut, Boolean
            s.option :newname, AttrName
          end
        }
        it{ should eq("[--allbut] [--newname=NEWNAME] OPERANDS") }
      end

      describe "on a signature with one argument only" do
        let(:signature){ 
          Signature.new do |s|
            s.argument :proj, AttrList
          end
        }
        it{ should eq("OPERANDS -- PROJ") }
      end

      describe "on a signature with multiple arguments" do
        let(:signature){ 
          Signature.new do |s|
            s.argument :proj, AttrList
            s.argument :ordering, Ordering
          end
        }
        it{ should eq("OPERANDS -- PROJ -- ORDERING") }
      end

      describe "on a full signature" do
        let(:signature){ 
          Signature.new do |s|
            s.argument :proj, AttrList
            s.argument :ordering, Ordering
            s.option :allbut, Boolean
            s.option :newname, AttrName
          end
        }
        it{ should eq("[--allbut] [--newname=NEWNAME] OPERANDS -- PROJ -- ORDERING") }
      end

      describe "when an unary operator is passed" do
        subject{ signature.to_shell_doc(Operator::Relational::Restrict) }
        let(:signature){ Signature.new{|s|} }
        it{ should eq("[OPERAND]") }
      end

      describe "when an binary operator is passed" do
        subject{ signature.to_shell_doc(Operator::Relational::Join) }
        let(:signature){ Signature.new{|s|} }
        it{ should eq("[LEFT] RIGHT") }
      end

    end
  end
end
