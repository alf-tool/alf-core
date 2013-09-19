require 'spec_helper'
module Alf
  describe Selection, "select" do

    subject{ selection.select(tuple) }

    let(:tuple){ {name: "foo", city: {name: "bar"}} }

    context 'on a selection of name' do
      let(:selection){ Selection.coerce(["name"]) }

      it{ should eq(["foo"]) }
    end

    context 'on a selection of city' do
      let(:selection){ Selection.coerce(["city"]) }

      it{ should eq([{name: "bar"}]) }
    end

    context 'on a selection of city.name' do
      let(:selection){ Selection.coerce(["city.name"]) }

      it{ should eq(["bar"]) }
    end

    context 'on a selection of name and city.name' do
      let(:selection){ Selection.coerce(["name", "city.name"]) }

      it{ should eq(["foo","bar"]) }
    end

  end
end
