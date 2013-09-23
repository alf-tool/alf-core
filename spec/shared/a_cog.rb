shared_examples_for 'a cog' do

  it { should be_a(Alf::Engine::Cog) }

  it 'should return self on to_cog' do
    subject.to_cog.should be(subject)
  end

end

shared_examples_for 'a traceable cog' do

  it_should_behave_like "a cog"

  def has_tracking!(compiled)
    compiled.expr.should_not be_nil
    case compiled
    when Alf::Engine::Leaf
      compiled.expr.should be_a(Alf::Algebra::Operand)
    when Alf::Engine::Cog
      compiled.expr.should be_a(Alf::Algebra::Operand)
      extract_operands(compiled).each do |op|
        has_tracking!(op)
      end
    else
      raise "Unexpected cog: #{compiled}"
    end
  end

  def extract_operands(compiled)
    return compiled.operands if compiled.respond_to?(:operands)
    return [compiled.operand] if compiled.respond_to?(:operand)
    []
  end

  it 'should have traceability all way down expression' do
    has_tracking!(subject)
  end

end
