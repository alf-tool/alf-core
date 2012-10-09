shared_examples_for "an adapter class" do

  describe 'recognizes?' do

    it 'returns true on recognized connection specifications' do
      recognized_conn_specs.each do |c|
        adapter_class.recognizes?(c).should be_true
      end
    end
  end

  describe 'new' do

    it 'returns an instance on recognized connection specifications' do
      recognized_conn_specs.each do |c|
        adapter_class.new(c).should be_a(adapter_class)
      end
    end
  end

end
