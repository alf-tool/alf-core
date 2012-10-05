require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_relvar" do

      let(:rv){ Base.new(:connection, :name) }

      subject{ rv.to_relvar }

      it{ should be(rv) }

    end
  end
end
