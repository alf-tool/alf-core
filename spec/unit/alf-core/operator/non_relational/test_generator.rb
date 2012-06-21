require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Generator do

      let(:operator_class){ Generator }
      it_should_behave_like("An operator class")

      subject{ operator.to_rel }

      context "empty args" do
        let(:expected){Relation[
          {:num => 1},
          {:num => 2},
          {:num => 3},
          {:num => 4},
          {:num => 5},
          {:num => 6},
          {:num => 7},
          {:num => 8},
          {:num => 9},
          {:num => 10},
        ]}

        context "with Lispy" do 
          let(:operator){ a_lispy.generator() }
          it{ should == expected }
        end

      end # empty args

      context "with a size" do
        let(:expected){Relation[
          {:num => 1},
          {:num => 2},
        ]}

        context "When factored with Lispy" do 
          let(:operator){ a_lispy.generator(2) }
          it{ should == expected }
        end

      end # with a size

      context "when providing a size and a name" do
        let(:expected){Relation[
          {:id => 1},
          {:id => 2},
        ]}

        context "When factored with Lispy" do 
          let(:operator){ a_lispy.generator(2, :id) }
          it{ should == expected }
        end

      end # size and name

    end 
  end
end
