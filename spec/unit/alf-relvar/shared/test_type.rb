require 'spec_helper'
module Alf
  describe Relvar, 'type' do
    include Relvar

    def heading(*)
      Heading.new(sid: Integer, name: String)
    end

    subject{ type }

    it 'returns the expected type' do
      subject.should eq(Relation[heading])
    end

    it 'memoizes used instance' do
      subject.should be(type)
    end

  end
end
