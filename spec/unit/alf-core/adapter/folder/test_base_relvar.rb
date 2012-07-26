require 'spec_helper'
module Alf
  class Adapter
    describe Folder, 'base_relvar' do

      let(:db){ Folder.new(Path.dir/'../examples') }

      subject{ db.base_relvar(name) }

      describe "when called on explicit file" do
        let(:name){ "suppliers.rash" }
        it{ should be_a(Relvar::Base) }
      end

      describe "when called on existing (String)" do
        let(:name){ "suppliers" }
        it{ should be_a(Relvar::Base) }
      end

      describe "when called on existing (Symbol)" do
        let(:name){ :suppliers }
        it{ should be_a(Relvar::Base) }
      end

      describe "when called on unexisting" do
        let(:name){ "notavalidone" }
        it 'raises an error' do
          lambda{
            subject
          }.should raise_error(Alf::NoSuchRelvarError)
        end
      end

    end
  end
end
