require 'spec_helper'
module Alf
  describe Tools, "pathable?" do
    include Tools

    it 'returns :to_str on a String' do
      pathable?("hello").should eq(:to_str)
    end

    it 'returns :path on a Path' do
      pathable?(Path("hello")).should eq(:path)
    end

    it 'returns :path on a File' do
      Path.here.open('r') do |f|
        pathable?(f).should eq(:path)
      end
    end

    it 'returns nil on 12' do
      pathable?(12).should be_nil
    end

    it 'returns nil on a StringIO' do
      pathable?(StringIO.new).should be_nil
    end

  end
end
