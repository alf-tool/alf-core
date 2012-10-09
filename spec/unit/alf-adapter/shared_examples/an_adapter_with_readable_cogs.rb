shared_examples_for "an adapter with readable cogs" do

  let(:connection){ adapter.connection }

  before do
    connection.should be_a(Alf::Adapter::Connection)
  end

  after do
    connection.close if connection
  end

  describe 'knows?' do

    it 'respond true to known cogs' do
      readable_cogs.each do |cog_name|
        connection.knows?(cog_name).should be_true
      end
    end
  end

  describe 'cog' do

    it 'returns a Cog instance' do
      readable_cogs.each do |cog_name|
        connection.cog(cog_name).should be_a(Alf::Engine::Cog)
      end
    end
  end

end
