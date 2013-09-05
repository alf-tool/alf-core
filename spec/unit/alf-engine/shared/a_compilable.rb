shared_examples_for 'a compilable' do

  it { should be_a(Alf::Engine::Compilable) }

  it 'should return a Cog on to_cog' do
    subject.to_cog.should be_a(Alf::Engine::Cog)
  end

  it 'has correct traceability' do
    subject.expr.should be(expr)
  end

end
