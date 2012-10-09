require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_relvar" do

      let(:rv){ Base.new(:name, :connection) }

      subject{ rv.to_relvar }

      it{ should be(rv) }

    end
  end
end
