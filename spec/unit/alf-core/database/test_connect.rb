require 'spec_helper'
module Alf
  describe Database, '.connect' do

    it 'recognizes a Path' do
      db = Database.connect examples_path
      db.should be_a(Database)
      db.lower_stage.should be_a(Alf::Adapter::Folder)
    end

    it 'recognizes an Adapter' do
      ad = Adapter.folder(examples_path)
      db = Database.connect(ad)
      db.should be_a(Database)
      db.lower_stage.should eq(ad)
    end

    it 'recognizes a Database' do
      db = Database.connect examples_path
      Database.connect(db).should eq(db)
    end

    it 'supports no argument at all' do
      Database.connect.should be_a(Database)
    end

  end # Database, '.connect'
end # module Alf