require 'spec_helper'
module Alf
  describe Database, 'new' do
    
    it 'is private' do
      lambda{ Database.new }.should raise_error(NoMethodError)
    end

  end
end