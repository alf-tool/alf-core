require 'spec_helper'
module Alf
  module Relvar
    describe Base, "connection" do

      let(:rv){ Base.new(:name, :connection) }

      subject{ rv.connection }

      it{ should eq(:connection) }

    end
  end
end
