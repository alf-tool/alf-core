require 'spec_helper'
module Alf
  module Relvar
    describe Base, "name" do

      let(:rv){ Base.new(:name, :connection) }

      subject{ rv.name }

      it{ should eq(:name) }

    end
  end
end
