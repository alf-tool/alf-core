require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "connection" do

      let(:rv){ Virtual.new(:expr, :connection) }

      subject{ rv.connection }

      it{ should eq(:connection) }

    end
  end
end
