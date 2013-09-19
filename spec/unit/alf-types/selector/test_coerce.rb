require 'spec_helper'
module Alf
  describe Selector, ".coerce" do

    subject{ Selector.coerce(arg) }

    before do
      subject.should be_a(Selector)
    end

    context 'on a Symbol' do
      let(:arg){ :name }

      it { should eq(Selector.new(:name)) }
    end

    context 'on a single string' do
      let(:arg){ "name" }

      it { should eq(Selector.new(:name)) }
    end

    context 'on a composite string' do
      let(:arg){ "a.name" }

      it { should eq(Selector.new([:a, :name])) }
    end

    context 'on an array of strings' do
      let(:arg){ ["a", "name"] }

      it { should eq(Selector.new([:a, :name])) }
    end

  end
end
