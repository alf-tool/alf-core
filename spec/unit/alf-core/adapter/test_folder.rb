require 'spec_helper'
module Alf
  class Adapter
    describe Folder do

      it 'should be registered' do
        Adapter.all.find{|n,c| c == Folder}.should_not be_nil
      end

      it 'should lead to an Adapter.folder method' do
        Adapter.should respond_to(:folder)
        Adapter.folder(Path.dir).should be_a(Folder)
      end

    end
  end
end
