require 'spec_helper'
module Alf
  describe Tools, "to_path" do
    include Tools

    it 'uses :to_str on a String' do
      to_path("hello").should eq(Path('hello'))
    end

    it 'uses :path on a Path' do
      to_path(Path("hello")).should eq(Path("hello"))
    end

    it 'returns :path on a File' do
      Path.here.open('r') do |f|
        to_path(f).should eq(Path.here)
      end
    end

    it 'returns nil on 12' do
      to_path(12).should be_nil
    end

    it 'returns the block value if provided' do
      to_path(12){ 11 }.should eq(11)
    end

  end
end
