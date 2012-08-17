require 'spec_helper'
module Alf
  module Algebra
    describe Rename do

      let(:operator_class){ Rename }

      it_should_behave_like("An operator class")

      subject{ a_lispy.rename([], {:a => :z}) }

      it{ should be_a(Rename) }

    end
  end
end
