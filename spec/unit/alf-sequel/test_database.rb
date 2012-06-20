require 'spec_helper'
require 'fileutils'
require "sequel"
module Alf
  describe Sequel::Database do
    
    let(:rel) {Alf::Relation[
      {:sid => 'S1', :name => 'Smith', :status => 20, :city => 'London'},
      {:sid => 'S2', :name => 'Jones', :status => 10, :city => 'Paris'},
      {:sid => 'S3', :name => 'Blake', :status => 30, :city => 'Paris'},
      {:sid => 'S4', :name => 'Clark', :status => 20, :city => 'London'},
      {:sid => 'S5', :name => 'Adams', :status => 30, :city => 'Athens'}
    ]}

    let(:file){ _("alf.db", __FILE__) }

    def uri
      protocol = defined?(JRUBY_VERSION) ? "jdbc:sqlite" : "sqlite"
      "#{protocol}://#{file}"
    end

    before(:all){
      unless File.exists?(file) 
        FileUtils.rm_rf file
        db = ::Sequel.connect(uri)
        db.create_table(:suppliers){
          primary_key :sid
          String  :sid
          String  :name
          Integer :status
          String  :city
        }
        rel.each{|tuple| db[:suppliers].insert(tuple)}
      end
    }

    describe "recognizes?" do

      it "should recognize sqlite files" do
        Sequel::Database.recognizes?([file]).should be_true
      end

      it "should recognize database uris" do
        Sequel::Database.recognizes?(["postgres://localhost/database"]).should be_true
        Sequel::Database.recognizes?([uri]).should be_true
      end

      it "should not be too permissive" do
        Sequel::Database.recognizes?(["nosuchone.db"]).should be_false
        Sequel::Database.recognizes?([nil]).should be_false
      end

    end # recognizes?

    it "should let Database autodetect sqlite files" do
      Database.autodetect(file).should be_a(Sequel::Database)
    end

    describe "dataset" do

      let(:db) { Sequel::Database.new(file) }

      it "should serve iterators" do
        db.dataset(:suppliers).should be_a(Alf::Iterator)
      end

      it "should be the correct relation" do
        db.dataset(:suppliers).to_rel.should eq(rel)
      end

    end # dataset

  end
end
