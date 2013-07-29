shared_examples_for 'an uncached connection method' do

  let(:connection){
    meth = connection_method
    Class.new(Alf::Adapter::Connection) do
      define_method(meth) do |*args, &bl|
        bl ? bl.call(args) : args
      end
    end.new(nil)
  }
  let(:cached){ Alf::Adapter::Connection::SchemaCached.new(connection) }

  it 'delegates the call to the connection' do
    args, seen = ["foo", :bar, 2], nil
    cached.send(connection_method, *args) do |res|
      seen = res
    end
    seen.should eq(args)
  end

end
