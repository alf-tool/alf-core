require 'spec_helper'
require 'fileutils'
require "sequel"
module Alf
  describe Sequel::Adapter, 'relvar' do

    let(:rel) {Alf::Relation[
      {:sid => 'S1', :name => 'Smith', :status => 20, :city => 'London'},
      {:sid => 'S2', :name => 'Jones', :status => 10, :city => 'Paris'},
      {:sid => 'S3', :name => 'Blake', :status => 30, :city => 'Paris'},
      {:sid => 'S4', :name => 'Clark', :status => 20, :city => 'London'},
      {:sid => 'S5', :name => 'Adams', :status => 30, :city => 'Athens'}
    ]}

    let(:file){ _("../alf.db", __FILE__) }
    let(:db) { Sequel::Adapter.new(file) }

    def uri
      protocol = defined?(JRUBY_VERSION) ? "jdbc:sqlite" : "sqlite"
      "#{protocol}://#{file}"
    end

    it "should serve relvars" do
      db.relvar(:suppliers).should be_a(Alf::Relvar)
    end

    it "should be the correct relation" do
      db.relvar(:suppliers).value.should eq(rel)
    end

    it 'raises a NoSuchRelvarError if not found' do
      lambda{
        db.relvar(:nosuchone)
      }.should raise_error(NoSuchRelvarError)
    end

  end
end
