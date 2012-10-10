require 'spec_helper'
module Alf
  class Database
    describe Options, "default_viewpoint" do
      include Options

      it 'is Viewpoint::NATIVE by default' do
        default_viewpoint.should be(Viewpoint::NATIVE)
      end

      it 'can be set' do
        mod = Module.new{ include Alf::Viewpoint }
        self.default_viewpoint = mod
        default_viewpoint.should be(mod)
      end

    end
  end
end
