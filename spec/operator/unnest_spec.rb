require 'spec_helper'
module Alf
  describe Unnest do
      
    let(:input) {[
      {:nested => {:a => "a", :b => "b"}, :c => "c"}
    ]}

    let(:expected) {[
      {:a => "a", :b => "b", :c => "c"},
    ]}

    subject{ operator.to_a }

    describe "when factored with commandline args" do
      let(:operator){ Unnest.run(%w{-- nested}) }
      before{ operator.pipe(input) }
      it { should == expected }
    end

    describe "when factored with Lispy" do
      let(:operator){ Lispy.unnest(input, :nested) }
      it { should == expected }
    end

  end 
end
