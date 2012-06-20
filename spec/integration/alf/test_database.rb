require 'spec_helper'
describe Alf, '.database' do

  it "should support an Database instance" do
    db = Alf::Database.examples
    Alf.database(db).should eq(db)
  end

  it "should recognize an existing folder" do
    db = Alf.database(File.dirname(__FILE__))
    db.should be_a(Alf::Database::Folder)
  end

  it "should recognize an existing folder through a Path instance" do
    db = Alf.database(Path.dir)
    db.should be_a(Alf::Database::Folder)
  end

end