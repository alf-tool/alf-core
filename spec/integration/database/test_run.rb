require 'spec_helper'
module Alf
  describe Database, "run" do

    let(:cities){Relation[
      {:city => "London"},
      {:city => "Paris"},
      {:city => "Athens"}
    ]}

    let(:database){ Database.examples }

    subject{ database.run(args).to_rel }

    describe "without any pipe, on a String" do
      let(:args){ "project suppliers -- city" }
      it{ should eq(cities) }
    end

    describe "without any pipe, on an Array" do
      let(:args){ %w{project suppliers -- city} }
      it{ should eq(cities) }
    end

    describe "with alf explicitely" do
      let(:args){ %w{alf project suppliers -- city} }
      it{ should eq(cities) }
    end

    describe "with piped commands" do
      let(:args){ %w{alf project suppliers -- city | alf extend -- upcased city.upcase} }
      it{ should eq(cities.extend(:upcased => lambda{ city.upcase })) }
    end

    describe "with piped commands and a dyadic op" do
      let(:args){ %w{alf project suppliers -- city | alf matching suppliers} }
      it{ should eq(cities) }
    end

  end
end
