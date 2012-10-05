require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "to_s" do

      let(:rv)  { Virtual.new(:connection, expr)              }
      let(:expr){ Struct.new(:to_s).new("a lispy expression") }

      subject{ rv.to_s }

      it{ should eq("Relvar::Virtual(a lispy expression)") }

    end
  end
end
