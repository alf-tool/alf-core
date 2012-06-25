require 'spec_helper'
module Alf
  module Lang
    describe Lispy, "Relation(...)" do

      let(:lispy){ Database.examples.lispy }

      subject{ lispy.Relation(*args) }

      describe 'on a single tuple' do
        let(:args){ [{:name => "Alf"}] }
        it{ should eq(Relation[*args]) }
      end

      describe 'on two tuples' do
        let(:args){ [{:name => "Alf"}, {:name => "Lispy"}] }
        it{ should eq(Relation[*args]) }
      end

    end
  end
end
