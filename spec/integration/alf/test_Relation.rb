require 'spec_helper'
module Alf
  describe "Relation" do

    let(:expected){ Alf::Relation.new([ {:name => "Jones"} ].to_set) }

    it 'works as expected on a tuple' do
      Alf::Relation(:name => "Jones").should eq(expected)
    end

    it 'works as expected on a Reader' do
      File.open(File.expand_path("../example.rash", __FILE__), "r") do |io|
        reader = Alf::Reader.rash(io)
        rel    = Alf::Relation(reader)
        rel.should eq(expected)
      end
    end

    it 'supports a Path to a recognized file' do
      Alf::Relation(Path.dir/'example.rash').should eq(expected)
    end

    it 'supports a String to a recognized file' do
      Alf::Relation(File.expand_path('../example.rash', __FILE__)).should eq(expected)
    end

    it 'is aliased as relation' do
      Alf.relation(:name => "Jones").should eq(expected)
    end

  end
end
