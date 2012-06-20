require 'spec_helper'
module Alf
  class Database
    describe Folder, "recognizes?" do

      it 'should return true on an existing path' do
        Folder.recognizes?([File.dirname(__FILE__)]).should be_true
      end

      it 'should return true on an existing Path instance' do
        Folder.recognizes?([Path.dir]).should be_true
      end

      it 'should return false on an non existing path' do
        Folder.recognizes?(["not/an/existing/one"]).should be_false
      end

    end
  end
end
