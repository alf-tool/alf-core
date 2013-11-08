require 'spec_helper'
module Alf
  describe Relvar, 'to_relation' do
    include Relvar

    subject{ to_relation }

    def to_cog
      Struct.new(:to_relation).new(:foo)
    end

    it{ should eq(:foo) }

  end
end
