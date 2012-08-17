require 'spec_helper'
module Alf
  module Algebra
    describe Signature, '#to_shell' do

      subject{ signature.to_shell }

      describe "on a nullary signature" do
        let(:clazz){ Generator }

        describe "on an empty signature" do
          let(:signature){ Signature.new(clazz){|s|} }
          it{ should eq("alf generator") }
        end

        describe "on an option-only signature" do
          let(:signature){ 
            Signature.new(clazz) do |s|
              s.option :allbut, Boolean
            end
          }
          it{ should eq("alf generator [--allbut]") }
        end

      end # nullary signature

      describe "on a monadic operator" do
        let(:clazz){ Coerce }

        describe "on an empty signature" do
          let(:signature){ Signature.new(clazz){|s|} }
          it{ should eq("alf coerce [OPERAND]") }
        end

        describe "on an option-only signature" do
          let(:signature){ 
            Signature.new(clazz) do |s|
              s.option :allbut, Boolean
            end
          }
          it{ should eq("alf coerce [--allbut] [OPERAND]") }
        end

        describe "on an option-only signature with multiple options" do
          let(:signature){ 
            Signature.new(clazz) do |s|
              s.option :allbut, Boolean
              s.option :newname, AttrName
            end
          }
          it{ should eq("alf coerce [--allbut] [--newname=NEWNAME] [OPERAND]") }
        end

        describe "on a signature with one argument only" do
          let(:signature){ 
            Signature.new(clazz) do |s|
              s.argument :proj, AttrList
            end
          }
          it{ should eq("alf coerce [OPERAND] -- PROJ") }
        end

        describe "on a signature with multiple arguments" do
          let(:signature){ 
            Signature.new(clazz) do |s|
              s.argument :proj, AttrList
              s.argument :ordering, Ordering
            end
          }
          it{ should eq("alf coerce [OPERAND] -- PROJ -- ORDERING") }
        end

        describe "on a full signature" do
          let(:signature){ 
            Signature.new(clazz) do |s|
              s.argument :proj, AttrList
              s.argument :ordering, Ordering
              s.option :allbut, Boolean
              s.option :newname, AttrName
            end
          }
          it{ should eq("alf coerce [--allbut] [--newname=NEWNAME] [OPERAND] -- PROJ -- ORDERING") }
        end

      end

      describe "on a dyadic operator" do
        let(:clazz){ Join }

        describe "on an option-only signature" do
          let(:signature){ 
            Signature.new(clazz) do |s|
              s.option :allbut, Boolean
            end
          }
          it{ should eq("alf join [--allbut] [LEFT] RIGHT") }
        end

      end

    end
  end
end
