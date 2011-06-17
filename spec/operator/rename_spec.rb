require 'spec_helper'
module Alf
  describe Rename do
      
    let(:operator_class){ Rename }
    it_should_behave_like("An operator class")
      
    let(:input) {[
      {:a => "a", :b => "b"},
    ]}

    let(:expected){[
      {:z => "a", :b => "b"},
    ]}

    subject{ operator.to_a }

    describe "When factored with Lispy" do 
      let(:operator){ Lispy.rename(input, {:a => :z}) }
      it{ should == expected }
    end

    describe "When factored from commandline args" do
      let(:operator){ Rename.run(['--', 'a', 'z']) }
      before{ operator.pipe(input) }
      it{ should == expected }
    end

  end 
end
