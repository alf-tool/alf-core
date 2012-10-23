require 'spec_helper'
module Alf
  describe Tuple, '.type' do

    let(:heading){ {name: String, status: Integer} }
    subject{ Tuple.type(heading) }

    it 'returns a subclass' do
      subject.should be_a(Class)
      subject.superclass.should be(Alf::Tuple)
    end

    it 'coerces the heading' do
      subject.heading.should be_a(Heading)
    end

    it 'sets the heading correctly' do
      subject.heading.to_hash.should eq(heading)
    end

    it 'is aliased as []' do
      Tuple[heading].should be_a(Class)
      Tuple[heading].should eq(subject)
    end

  end
end
