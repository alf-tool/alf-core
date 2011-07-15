require 'spec_helper'
describe "path attributes in log" do
  
  let(:env){ Alf::Environment.folder(File.dirname(__FILE__)) }
    
  subject{ 
    Alf.lispy(env).evaluate {
      (restrict :apache_combined, lambda{ path =~ /install.txt/ })
    }
  }
  
  specify {
    subject.should be_a(Alf::Relation)
    subject.project([:path]).should == Alf::Relation[
      {:path => "/cart/install.txt" }, 
      {:path => "/store/install.txt"}
    ]
  }
  
end