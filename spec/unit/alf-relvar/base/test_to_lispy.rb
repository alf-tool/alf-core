require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_lispy" do

      let(:rv){ Base.new(:connection, :name) }

      subject{ rv.to_lispy }

      it{ should eq("name") }

    end
  end
end
