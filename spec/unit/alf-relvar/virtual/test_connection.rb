require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "connection" do

      let(:rv){ Virtual.new(:connection, :expr) }

      subject{ rv.connection }

      it{ should eq(:connection) }

    end
  end
end
