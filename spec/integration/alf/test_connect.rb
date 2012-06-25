require 'spec_helper'
describe Alf, '.connect' do

  it "should support an Database instance" do
    db = examples_database
    Alf.connect(db).should eq(db)
  end

  it "should recognize an existing folder" do
    db = Alf.connect(File.dirname(__FILE__))
    db.should be_a(Alf::Connection)
    db.adapter.should be_a(Alf::Adapter::Folder)
  end

  it "should recognize an existing folder through a Path instance" do
    db = Alf.connect(Path.dir)
    db.should be_a(Alf::Connection)
    db.adapter.should be_a(Alf::Adapter::Folder)
  end

end