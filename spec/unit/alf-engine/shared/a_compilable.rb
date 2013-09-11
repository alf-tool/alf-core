shared_examples_for 'a compilable' do

  it { should be_a(Alf::Engine::Cog) }

  it 'has correct traceability' do
    subject.expr.should be(expr)
  end

end
