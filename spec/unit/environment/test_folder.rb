require 'spec_helper'
module Alf
  class Environment
    describe Folder do

      it 'should be registered' do
        Environment.environments.find{|n,c| c == Folder}.should_not be_nil
      end

      it 'should lead to an Environment.folder method' do
        Environment.should respond_to(:folder)
        Environment.folder(File.dirname(__FILE__)).should be_a(Folder)
      end

      let(:path){ File.expand_path('../examples', __FILE__) }
      let(:env){ Folder.new(path) }

      describe "recognizes?" do

        it 'should return true on an existing path' do
          Folder.recognizes?([File.dirname(__FILE__)]).should be_true
        end

        it 'should return false on an non existing path' do
          Folder.recognizes?(["not/an/existing/one"]).should be_false
        end

      end # recognizes?

      describe "dataset" do

        subject{ env.dataset(name) }

        describe "when called on explicit file" do
          let(:name){ "suppliers.rash" }
          it{ should be_a(Reader::Rash) }
        end

        describe "when called on existing" do
          let(:name){ "suppliers" }
          it{ should be_a(Reader::Rash) }
        end

        describe "when called on unexisting" do
          let(:name){ "notavalidone" }
          specify{ lambda{ subject }.should raise_error(Alf::NoSuchDatasetError) }
        end

      end # dataset

    end
  end
end
