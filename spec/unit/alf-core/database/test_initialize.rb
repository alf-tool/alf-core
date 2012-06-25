require 'spec_helper'
module Alf
  describe Database, 'initialize' do
    
    it 'supports no argument' do
      Database.new.should be_a(Database)
    end

  end
end