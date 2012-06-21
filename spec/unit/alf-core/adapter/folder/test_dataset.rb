require 'spec_helper'
module Alf
  class Adapter
    describe Folder, 'dataset' do

      let(:db){ Folder.new(Path.dir/'../examples') }

      subject{ db.dataset(name) }

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

    end
  end
end
