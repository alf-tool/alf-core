require 'spec_helper'
module Alf
  describe "Alf's examples" do
    
    shared_examples_for "An example" do
      
      let(:env){ Environment.examples }

      it "should work when executed with a Alf" do
        lambda{ 
          Alf.lispy(env).compile(File.read(subject)).to_rel
        }.should_not raise_error
      end
      
    end # An example
    
    
    Dir["#{File.expand_path('../../../examples', __FILE__)}/**/*.alf"].each do |file|
      describe file do
        subject{ file }
        it_should_behave_like "An example"
      end
    end
    
  end
end 