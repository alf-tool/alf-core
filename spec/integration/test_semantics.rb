require 'spec_helper'
describe "Alf's semantics tests" do
  
  module Helpers
    
    def rel_equal(x, y)
      x = examples_database.relvar(x).value if x.is_a?(Symbol)
      y = examples_database.relvar(y).value if y.is_a?(Symbol)
      x.to_rel == y.to_rel
    end
    
    def specify(message, x)
      ::Kernel.raise message unless x
    end
    
  end
  
  shared_examples_for "A semantics spec file" do
    
    let(:conn){
      Class.new(Alf::Database){
        helpers Helpers
      }.connect(Path.dir/'__database__')
    }

    it "should work when executed with a Alf" do
      conn.evaluate(Path(subject).read)
    end
    
  end # An example
  
  
  Dir["#{File.expand_path('../semantics', __FILE__)}/**/*.alf"].each do |file|
    describe file do
      subject{ file }
      it_should_behave_like "A semantics spec file"
    end
  end
  
end
