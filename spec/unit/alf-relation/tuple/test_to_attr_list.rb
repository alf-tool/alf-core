require 'spec_helper'
module Alf
  describe Tuple, "to_attr_list" do

    subject{ tuple.to_attr_list }

    let(:tuple){ Tuple.coerce(name: "Smith", status: 12) }

    it{ should eq(AttrList[:name, :status]) }

  end
end
