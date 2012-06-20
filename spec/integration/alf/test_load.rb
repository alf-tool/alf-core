require 'spec_helper'
describe Alf, '.load' do

  let(:expected){ Relation(:name => "Jones") }

  it 'supports a Path to a recognized file' do
    Alf.load(Path.dir/'example.rash').should eq(expected)
  end

  it 'supports a String to a recognized file' do
    Alf.load(File.expand_path('../example.rash', __FILE__)).should eq(expected)
  end

end
