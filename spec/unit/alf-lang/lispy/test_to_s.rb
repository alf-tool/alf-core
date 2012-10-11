require 'spec_helper'
module Alf
  module Lang
    describe Lispy, 'to_s' do

      let(:lispy){ Lispy.new }

      subject{ lispy.to_s }

      it{ should eq("Lispy(Alf::Lang::Functional,Alf::Lang::Predicates)") }

    end
  end
end
