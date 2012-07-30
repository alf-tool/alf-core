require 'spec_helper'
module Alf
  describe Database, 'new' do

    subject{ Database.new(Connection.folder '.') }

    it{ should be_a(Database) }

  end
end