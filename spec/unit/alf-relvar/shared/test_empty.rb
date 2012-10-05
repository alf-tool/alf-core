require 'spec_helper'
module Alf
  describe Relvar, 'empty?' do
    include Relvar

    subject{ empty? }

    context 'on an empty relvar' do
      let(:to_cog){ [] }

      it{ should be_true }
    end

    context 'on an non empty relvar' do
      let(:to_cog){ [ 1 ] }

      it{ should be_false }
    end

  end
end
