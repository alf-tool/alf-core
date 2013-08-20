require 'spec_helper'
Dir["#{File.expand_path('../../../examples', __FILE__)}/**/*.alf"].each do |file|

  describe "Alf example: #{file}" do
    let(:example_path){ file }
    let(:example_dir) { File.dirname(file) }
    let(:example_db) { Alf.connect(example_dir) }

    let(:source){ File.read(example_path) }

    def has_tracking!(compiled)
      case compiled
      when Alf::Engine::Leaf
        compiled.expr.should be_a(Alf::Algebra::Operand)
      when Alf::Engine::Cog
        compiled.expr.should be_a(Alf::Algebra::Operand)
        operands = compiled.respond_to?(:operands) ?
                   compiled.operands :
                   [ compiled.operand ]
        operands.each do |op|
          has_tracking!(op)
        end
      else
        raise "Unexpected cog: #{compiled}"
      end
    end

    it 'should properly compile and keep track of expressions' do
      expr     = example_db.parse(source)
      compiled = example_db.compile(expr)
      has_tracking!(compiled)
    end

    it "should run without error" do
      example_db.query(source, example_path)
    end
  end

end