require 'spec_helper'
describe Alf, '.connect' do

  it "recognizes an existing folder" do
    db = Alf.connect(File.dirname(__FILE__))
    db.should be_a(Alf::Database::Connection)
  end

  it "recognizes an existing folder through a Path instance" do
    db = Alf.connect(Path.dir)
    db.should be_a(Alf::Database::Connection)
  end

  it 'yields the connection if a block and returns its result' do
    seen = nil
    res  = Alf.connect(Path.dir) do |db|
      db.should be_a(Alf::Database::Connection)
      seen = db
      12
    end
    res.should eq(12)
    seen.should_not be_nil
  end

end
