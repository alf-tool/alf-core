require 'spec_helper'
describe Alf, '.database' do

  subject{ Alf.database(Path.dir, schema_cache: false){|d| @seen = d} }

  it{ should be_a(Alf::Database) }

  it 'coerces the adapter' do
    subject.adapter.should be_a(Alf::Adapter::Folder)
  end

  it 'sets the options' do
    subject.schema_cache?.should eq(false)
  end

  it 'yields the options to the block' do
    subject
    @seen.should be_a(Alf::Database::Options)
  end

end
