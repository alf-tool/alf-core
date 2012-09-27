require 'spec_helper'
module Alf
  module Types
    describe Tuple, "extend" do

      let(:tuple){ Tuple(:id => 1, :name => "Alf") }

      subject{ tuple.extend(:up => lambda{ name.upcase }) }

      it { should eq(Tuple.new(:id => 1, :name => "Alf", :up => "ALF")) }

    end
  end
end