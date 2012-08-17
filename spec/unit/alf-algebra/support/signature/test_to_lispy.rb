require 'spec_helper'
module Alf
  module Algebra
    describe Signature, '#to_lispy' do

      subject{ signature.to_lispy }

      describe "on a nullary signature" do
        let(:clazz){ Generator }

        describe "on an empty signature" do
          let(:signature){ Signature.new(clazz){|s|} }
          it{ should eq("(generator)") }
        end

        describe "on an option-only signature" do
          let(:signature){
            Signature.new(clazz) do |s|
              s.option :allbut, Boolean
            end
          }
          it{ should eq("(generator {allbut: Boolean})") }
        end

      end # nullary signature

      describe "on a monadic operator" do
        let(:clazz){ Coerce }

        describe "on an empty signature" do
          let(:signature){ Signature.new(clazz){|s|} }
          it{ should eq("(coerce operand)") }
        end

        describe "on an option-only signature" do
          let(:signature){
            Signature.new(clazz) do |s|
              s.option :allbut, Boolean
            end
          }
          it{ should eq("(coerce operand, {allbut: Boolean})") }
        end

        describe "on an option-only signature with multiple options" do
          let(:signature){
            Signature.new(clazz) do |s|
              s.option :allbut, Boolean
              s.option :newname, AttrName
            end
          }
          it{ should eq("(coerce operand, {allbut: Boolean, newname: AttrName})") }
        end

        describe "on a signature with one argument only" do
          let(:signature){
            Signature.new(clazz) do |s|
              s.argument :by, AttrList
            end
          }
          it{ should eq("(coerce operand, by:AttrList)") }
        end

        describe "on a signature with multiple arguments" do
          let(:signature){
            Signature.new(clazz) do |s|
              s.argument :by, AttrList
              s.argument :order, Ordering
            end
          }
          it{ should eq("(coerce operand, by:AttrList, order:Ordering)") }
        end

        describe "on a full signature" do
          let(:signature){
            Signature.new(clazz) do |s|
              s.argument :by, AttrList
              s.argument :order, Ordering
              s.option :allbut, Boolean
            end
          }
          it{ should eq("(coerce operand, by:AttrList, order:Ordering, {allbut: Boolean})") }
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
          it{ should eq("(join left, right, {allbut: Boolean})") }
        end

      end

    end
  end
end
