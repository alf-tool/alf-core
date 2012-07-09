require 'spec_helper'
describe "/spec/integration/semantics/" do

  module SemanticsHelpers

    def rel_equal(x, y)
      examples_database = Alf::Database.examples
      compiler = Alf::Engine::Compiler.new(examples_database)
      x = Alf::Tools.to_relation compiler.compile(x)
      y = Alf::Tools.to_relation compiler.compile(y)
      x == y
    end

    def specify(message, x)
      ::Kernel.raise message unless x
    end

  end

  shared_examples_for "a semantics file" do
    let(:conn){
      Class.new(Alf::Database){
        helpers SemanticsHelpers
      }.connect(Path.dir/'__database__')
    }

    it "works without error" do
      conn.evaluate(Path(subject).read)
    end
  end # An example


  Dir["#{File.expand_path('../semantics', __FILE__)}/**/*.alf"].each do |file|
    describe Path(file).basename do
      subject{ file }
      it_should_behave_like "a semantics file"
    end
  end

end
