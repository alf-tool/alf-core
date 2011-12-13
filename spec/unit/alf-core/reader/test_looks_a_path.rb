require 'spec_helper'
module Alf
  describe Reader, "looks_a_path?" do

    it 'should recognize strings' do
      Reader.send(:looks_a_path?, "path/to/a/file.rash").should be_true
    end

    it 'should recognize XXX#path' do
      obj = Object.new
      def obj.to_path; end
      Reader.send(:looks_a_path?, obj).should be_true
    end

    it 'should not recognize StringIO' do
      Reader.send(:looks_a_path?, StringIO.new("")).should be_false
    end

  end
end
