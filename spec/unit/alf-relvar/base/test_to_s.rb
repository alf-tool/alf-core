require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_s" do

      let(:rv){ Base.new(:name, :connection) }

      subject{ rv.to_s }

      it{ should eq("Relvar::Base(:name)") }

    end
  end
end
