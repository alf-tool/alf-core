shared_examples_for "A valid type implementation" do

  it 'should have exemplars available' do
    type.exemplars.should_not be_empty
    type.exemplars.each do |value|
      (type === value).should be_true
    end
  end

  it 'should define dupable values' do
    type.exemplars.each do |ex|
      ex.dup.should eq(ex)
      ex.dup.object_id.should_not eq(ex.object_id)
    end
  end

  it 'should define values that appear same in arrays' do
    type.exemplars.each do |ex|
      [ex, ex.dup, ex].uniq.should eq([ex])
    end
  end

  it 'should define values with correct hash codes' do
    type.exemplars.each do |ex|
      ex.dup.hash.should eq(ex.hash)
    end
  end

  it 'should define values that can be used as Hash keys' do
    type.exemplars.each do |ex|
      {ex => 1, ex.dup => 2}.size.should eq(1)
    end
  end

  it 'should define values respecting the :to_ruby_literal spec' do
    type.exemplars.each do |ex|
      Kernel.eval(ex.to_ruby_literal).should eq(ex)
    end
  end

  it 'should define values respecting the :inspect spec' do
    type.exemplars.each do |ex|
      Kernel.eval(ex.inspect).should eq(ex)
    end
  end

end
