require 'spec_helper'
module Alf
  class Database
    describe Options, "default_viewpoint" do

      subject{ opts.default_viewpoint }

      let(:opts){ Options.new }

      context 'by default' do

        it { should be(Viewpoint::NATIVE) }
      end

      context 'when explicitely set' do
        let(:mod){ Module.new{ include Alf::Viewpoint } }

        before{ opts.default_viewpoint = mod }

        it{ should be(mod) }
      end

    end
  end
end
