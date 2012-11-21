require 'spec_helper'
module Alf
  describe Relvar, 'safe' do

    let(:relvar){ Relvar::Fake.new(name: String) }

    subject{ relvar.safe(hello: "world") }

    it 'returns a Safe relvar' do
      subject.should be_a(Relvar::Safe)
    end

    it 'sets the relvar correctly' do
      subject.relvar.should be(relvar)
    end

    it 'sets the options correctly' do
      subject.options[:hello].should eq("world")
    end

  end
end
