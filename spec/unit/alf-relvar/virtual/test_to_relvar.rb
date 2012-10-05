require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_relvar" do

      let(:rv){ Virtual.new(:connection, :expr) }

      subject{ rv.to_relvar }

      it{ should be(rv) }

    end
  end
end
