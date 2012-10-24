shared_examples_for "a Reader class" do

  it 'should be a subclass of Reader' do
    described_class.ancestors.should include(Alf::Reader)
  end

  it "has a default mime type" do
    described_class.should respond_to(:mime_type)
  end

  describe "an instance" do
    let(:reader){ described_class.new(StringIO.new("")) }

    it 'returns a Enumerator with #each without block' do
      reader.each.should be_a(Enumerator)
    end
  end

end
