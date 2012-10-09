require 'spec_helper'
describe Alf, 'reader' do

  def reader(*args, &bl)
    Alf.reader(*args, &bl)
  end

  it 'supports a simple String' do
    reader(File.expand_path('../example.rash', __FILE__)).should be_a(Alf::Reader)
  end

  it 'supports a Path' do
    reader(Path.dir/'example.rash').should be_a(Alf::Reader) 
  end

  it 'supports a File' do
    (Path.dir/'example.rash').open('r') do |file|
      reader(file).should be_a(Alf::Reader)
    end
  end

end