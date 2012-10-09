require 'spec_helper'
module Alf
  describe Adapter, ".factor" do

    subject{ Adapter.factor(conn_spec) }

    context "on a path" do
      let(:conn_spec){ Path.dir }

      it{ should be_a(Adapter::Folder) }
    end

  end
end