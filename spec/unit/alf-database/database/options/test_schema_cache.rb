require 'spec_helper'
module Alf
  class Database
    describe Options, "schema_cache" do
      include Options

      it 'is true by default' do
        schema_cache?.should eq(true)
      end

      it 'can be set' do
        self.schema_cache = false
        schema_cache?.should eq(false)
      end

      it 'coerces the set value' do
        self.schema_cache = "false"
        schema_cache?.should eq(false)
      end

    end
  end
end
