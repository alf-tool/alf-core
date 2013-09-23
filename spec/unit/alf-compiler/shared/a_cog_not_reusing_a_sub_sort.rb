shared_examples_for "a cog not reusing a sub Sort" do

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
