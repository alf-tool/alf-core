require 'spec_helper'
module Alf
  module Lang
    module Parser
      describe Lispy, 'to_s' do

        let(:lispy){ Lispy.new }

        subject{ lispy.to_s }

        it{ should eq("Lispy()") }

      end
    end
  end
end
