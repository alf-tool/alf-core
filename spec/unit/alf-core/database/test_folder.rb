require 'spec_helper'
module Alf
  class Database
    describe Folder do

      it 'should be registered' do
        Database.databases.find{|n,c| c == Folder}.should_not be_nil
      end

      it 'should lead to an Database.folder method' do
        Database.should respond_to(:folder)
        Database.folder(Path.dir).should be_a(Folder)
      end

    end
  end
end
