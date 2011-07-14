require 'spec_helper'
describe "Alf's semantics tests" do
  
  module Helpers
    
    def rel_equal(x, y)
      x = Alf::Environment.examples.dataset(x) if x.is_a?(Symbol)
      y = Alf::Environment.examples.dataset(y) if y.is_a?(Symbol)
      x.to_rel == y.to_rel
    end
    
    def specify(message, x)
      raise message unless x
    end
    
  end
  
  shared_examples_for "A semantics spec file" do
    
    let(:lispy){
      lispy = Alf.lispy(Alf::Environment.examples)
      lispy.ruby_extend(Helpers)
    }

    it "should work when executed with a Alf" do
      lispy.compile(File.read(subject))
    end
    
  end # An example
  
  
  Dir["#{File.expand_path('../semantics', __FILE__)}/**/*.alf"].each do |file|
    describe file do
      subject{ file }
      it_should_behave_like "A semantics spec file"
    end
  end
  
end
