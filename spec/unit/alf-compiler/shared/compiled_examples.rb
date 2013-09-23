shared_examples_for 'a traceable compiled' do

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

  it 'should have the compiler' do
    subject.compiler.should be(compiler)
  end

  it 'should have traceability all way down expression' do
    has_tracking!(subject)
  end

end

shared_examples_for "a compiled not reusing a sub Sort" do

  it 'has a Sort as sub-cog' do
    subject.operand.should be_a(Alf::Engine::Sort)
    subject.operand.ordering.should eq(ordering)
  end

  it 'has a Sort has sub-sub cog' do
    subject.operand.operand.should be_a(Alf::Engine::Sort)
    subject.operand.operand.ordering.should be(subordering)
  end

  it 'has the leaf has sub-sub-sub cog' do
    subject.operand.operand.operand.should be(leaf)
  end

end

shared_examples_for "a compiled based on an added sub Sort" do

  it 'has a Sort as sub-cog' do
    subject.operand.should be_a(Alf::Engine::Sort)
    subject.operand.ordering.should eq(ordering)
  end

  it 'has the leaf has sub-sub cog' do
    subject.operand.operand.should be(leaf)
  end

end

shared_examples_for "a compiled based on an added reversed Sort" do

  it 'has a Sort as sub-cog' do
    subject.operand.should be_a(Alf::Engine::Sort)
    subject.operand.ordering.should eq(ordering.reverse)
  end

  it 'has the leaf has sub-sub cog' do
    subject.operand.operand.should be(leaf)
  end

end

shared_examples_for "a compiled reusing a sub Sort" do

  it 'has the Sort as sub-cog' do
    subject.operand.should be_a(Alf::Engine::Sort)
    subject.operand.ordering.should be(subordering)
    subject.operand.operand.should be(leaf)
  end

end
