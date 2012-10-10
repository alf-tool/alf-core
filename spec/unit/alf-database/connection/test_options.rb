require 'spec_helper'
module Alf
  class Database
    describe Connection, "options" do

      subject{ sap_conn }

      it_should_behave_like "a facade on database options"

      it 'should allow options to be consulted' do
        subject.options.should be_a(Database::Options)
      end

    end
  end
end
