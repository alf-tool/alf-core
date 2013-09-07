require 'spec_helper'
module Alf
  describe Selector, ".coerce" do

    subject{ Selector.coerce(arg) }

    context 'on a Symbol' do
      let(:arg){ :name }

      it { should be(arg) }
    end

    context 'on a single string' do
      let(:arg){ "name" }

      it { should be(arg.to_sym) }
    end

    context 'on a composite string' do
      let(:arg){ "a.name" }

      it { should eq([:a, :name]) }
    end

    context 'on an array of strings' do
      let(:arg){ ["a", "name"] }

      it { should eq([:a, :name]) }
    end

  end
end
