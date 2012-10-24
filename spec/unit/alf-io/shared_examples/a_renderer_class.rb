shared_examples_for "a Renderer class" do

  it 'should be a subclass of Renderer' do
    subject.ancestors.should include(Alf::Renderer)
  end

  it "has a default mime type" do
    subject.should respond_to(:mime_type)
  end

  describe "an instance" do
    let(:renderer){ subject.new([{id: 1}]) }

    it 'renders and returns a buffer with #execute' do
      buf = ""
      renderer.execute(buf).should be(buf)
    end

    it 'returns a Enumerator with #each without block' do
      renderer.each.should be_a(Enumerator)
    end
  end

end
