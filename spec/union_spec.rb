require File.expand_path('../spec_helper', __FILE__)
module Alf
  describe Union do
      
    let(:left) {[
      {:city => 'London'},
      {:city => 'Paris'},
      {:city => 'Paris'}
    ]}

    let(:right) {[
      {:city => 'Oslo'},
      {:city => 'Paris'}
    ]}

    let(:operator){ Union.run([]) }
    subject{ operator.to_a }

    describe "when applied on non disjoint sets" do
      before{ operator.datasets = [left, right] }
      let(:expected){[
        {:city => 'London'},
        {:city => 'Paris'},
        {:city => 'Oslo'}
      ]}
      it { should == expected }
    end

  end 
end
