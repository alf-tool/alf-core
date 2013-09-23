shared_examples_for "a cog reusing a sub Sort" do

  it 'has the Sort as sub-cog' do
    subject.operand.should be_a(Alf::Engine::Sort)
    subject.operand.ordering.should be(subordering)
    subject.operand.operand.should be(leaf)
  end

end
