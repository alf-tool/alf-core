require 'spec_helper'
module Alf
  describe Selector, "select" do

    subject{ selector.select(tuple) }

    let(:tuple){ {name: "foo", city: {name: "bar"}} }

    context 'on name' do
      let(:selector){ Selector.coerce("name") }

      it{ should eq("foo") }
    end

    context 'on city' do
      let(:selector){ Selector.coerce("city") }

      it{ should eq(name: "bar") }
    end

    context 'on unexisting' do
      let(:selector){ Selector.coerce("unexisting") }

      it{ should be_nil }
    end

    context 'on unexisting composite' do
      let(:selector){ Selector.coerce("city.unexisting") }

      it{ should be_nil }
    end

    context 'on unexisting composite II' do
      let(:selector){ Selector.coerce("cities.unexisting") }

      it{ should be_nil }
    end

  end
end
