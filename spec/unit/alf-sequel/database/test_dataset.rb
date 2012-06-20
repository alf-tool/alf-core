require 'spec_helper'
require 'fileutils'
require "sequel"
module Alf
  describe Sequel::Database, 'dataset' do
    
    let(:rel) {Alf::Relation[
      {:sid => 'S1', :name => 'Smith', :status => 20, :city => 'London'},
      {:sid => 'S2', :name => 'Jones', :status => 10, :city => 'Paris'},
      {:sid => 'S3', :name => 'Blake', :status => 30, :city => 'Paris'},
      {:sid => 'S4', :name => 'Clark', :status => 20, :city => 'London'},
      {:sid => 'S5', :name => 'Adams', :status => 30, :city => 'Athens'}
    ]}

    let(:file){ _("../alf.db", __FILE__) }
    let(:db) { Sequel::Database.new(file) }

    def uri
      protocol = defined?(JRUBY_VERSION) ? "jdbc:sqlite" : "sqlite"
      "#{protocol}://#{file}"
    end

    it "should serve iterators" do
      db.dataset(:suppliers).should be_a(Alf::Iterator)
    end

    it "should be the correct relation" do
      db.dataset(:suppliers).to_rel.should eq(rel)
    end

  end
end
