require 'spec_helper'
module Alf
  describe Database, '.connect' do

    it 'recognizes a Path' do
      db = Database.connect examples_path
      db.should be_a(Database)
      db.connection.should be_a(Connection::Folder)
    end

  end # Database, '.connect'
end # module Alf