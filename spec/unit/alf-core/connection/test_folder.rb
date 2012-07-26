require 'spec_helper'
module Alf
  class Connection
    describe Folder do

      it 'should be registered' do
        Connection.all.find{|n,c| c == Folder}.should_not be_nil
      end

      it 'should lead to an Connection.folder method' do
        Connection.should respond_to(:folder)
        Connection.folder(Path.dir).should be_a(Folder)
      end

    end
  end
end
