shared_examples_for "a cog adding a reversed Sort" do

  it 'has a Sort as sub-cog' do
    subject.operand.should be_a(Alf::Engine::Sort)
    subject.operand.ordering.should eq(ordering.reverse)
  end

  it 'has the leaf has sub-sub cog' do
    subject.operand.operand.should be(leaf)
  end

end
