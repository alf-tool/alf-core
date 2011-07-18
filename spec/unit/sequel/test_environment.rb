require 'spec_helper'
require 'fileutils'
require "sequel"
module Alf
  describe Sequel::Environment do
    
    let(:rel) {Alf::Relation[
      {:sid => 'S1', :name => 'Smith', :status => 20, :city => 'London'},
      {:sid => 'S2', :name => 'Jones', :status => 10, :city => 'Paris'},
      {:sid => 'S3', :name => 'Blake', :status => 30, :city => 'Paris'},
      {:sid => 'S4', :name => 'Clark', :status => 20, :city => 'London'},
      {:sid => 'S5', :name => 'Adams', :status => 30, :city => 'Athens'}
    ]}

    let(:file){ _("alf.db", __FILE__) }
    let(:uri) { "sqlite://#{file}"    }
    let(:env) { Sequel::Environment.new(uri) }
    
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
    
    specify{
      env.should be_a(Alf::Environment)
    }
    
    it "should serve iterators" do
      env.dataset(:suppliers).should be_a(Alf::Iterator)
    end
    
    it "should be the correct relation" do
      env.dataset(:suppliers).to_rel.should eq(rel)
    end
    
    specify ".recognizes?" do
      Sequel::Environment.recognizes?([_("alf.db", __FILE__)]).should be_true
      Sequel::Environment.recognizes?(["postgres://localhost/database"]).should be_true
      Sequel::Environment.recognizes?(["nosuchone.db"]).should be_false
      Sequel::Environment.recognizes?([nil]).should be_false
    end
      
  end
end