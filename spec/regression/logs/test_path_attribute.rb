require 'spec_helper'
describe "path attributes in log" do
  
  let(:env){ Alf::Environment.folder(File.dirname(__FILE__)) }
    
  subject{ 
    Alf.lispy(env).evaluate {
      (restrict :apache_combined, lambda{ path =~ /install.txt/ })
    }
  }
  
  it { should be_a(Alf::Relation) }
  
end