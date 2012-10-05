require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "expr" do

      let(:rv){ Virtual.new(:connection, :expr) }

      subject{ rv.expr }

      it{ should eq(:expr) }

    end
  end
end
