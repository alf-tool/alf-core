require 'spec_helper'
module Alf
  describe Database, '.connect' do

    it 'recognizes a Path' do
      db = Database.connect examples_path
      db.should be_a(Alf::Adapter::Folder)
    end

    it 'recognizes an Adapter' do
      ad = Adapter.folder(examples_path)
      db = Database.connect(ad)
      db.should be_a(Alf::Adapter::Folder)
    end

  end # Database, '.connect'
end # module Alf