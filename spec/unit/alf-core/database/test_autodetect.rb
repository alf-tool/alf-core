require 'spec_helper'
module Alf
  describe Database, '.autodetect' do

    it 'recognizes a Path' do
      db = Database.autodetect examples_path
      db.should be_a(Database)
      db.lower_stage.should be_a(Alf::Adapter::Folder)
    end

    it 'recognizes a Database' do
      db = Database.autodetect examples_path
      Database.autodetect(db).should eq(db)
    end

  end # Database, '.autodetect'
end # module Alf