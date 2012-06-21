require 'spec_helper'
describe "path attributes in log" do
  
  let(:db){ Alf::Database.folder(Path.dir) }
    
  subject{ 
    db.evaluate <<-EOF
      (restrict :apache_combined, lambda{ path =~ /install.txt/ })
    EOF
  }
  
  specify {
    subject.should be_a(Alf::Relation)
    projected = subject.project([:path])
    projected.should == Alf::Relation[
      {:path => "/cart/install.txt" }, 
      {:path => "/store/install.txt"}
    ]
    projected.extend(:short_path => lambda{ path[0..1] }).should == Alf::Relation[
      {:path => "/cart/install.txt",  :short_path => "/c" }, 
      {:path => "/store/install.txt", :short_path => "/s"}
    ]
  }
  
end