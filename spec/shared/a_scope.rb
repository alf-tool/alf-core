shared_examples_for "A scope" do

  it 'responds to its own methods' do
    subject.respond_to?(:respond_to?).should be_true
    subject.respond_to?(:evaluate).should be_true
    subject.respond_to?(:__eval_binding).should be_true
  end

  it 'responds to needed kernel methods' do
    subject.respond_to?(:lambda).should be_true
  end

  it "responds to BasicObject's API" do
    subject.respond_to?(:instance_eval).should be_true
  end
  
  it 'does not respond to anything' do
    subject.respond_to?(:anything_else).should be_false
  end

end
