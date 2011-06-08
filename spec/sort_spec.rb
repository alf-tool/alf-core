require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Restrict do
      
    let(:input) {[
      {:first => "a", :second => 20,  :third => true},
      {:first => "b", :second => 10, :third => false},
      {:first => "a", :second => 1,  :third => true},
    ]}

    let(:expected){[
      {:first => "a", :second => 1,  :third => true},
      {:first => "a", :second => 20, :third => true},
      {:first => "b", :second => 10, :third => false},
    ]}

    subject{ operator.to_a }

    describe "When factored with Lispy" do 
      let(:operator){ Lispy.sort(input, [:first, :second]) }
      it{ should == expected }
    end

    describe "When factored from commandline args" do
      let(:operator){ Sort.new.set_args(["first", "second"]).pipe(input) }
      it{ should == expected }
    end

    describe "When used on two args" do 
      let(:operator){ Lispy.sort(input, [:second, :first]) }
      let(:expected){[
        {:first => "a", :second => 1,  :third => true},
        {:first => "b", :second => 10, :third => false},
        {:first => "a", :second => 20, :third => true},
      ]}
      it{ should == expected }
    end

    describe "When used on single arg" do 
      let(:operator){ Lispy.sort(input, [:second]) }
      let(:expected){[
        {:first => "a", :second => 1,  :third => true},
        {:first => "b", :second => 10, :third => false},
        {:first => "a", :second => 20, :third => true},
      ]}
      it{ should == expected }
    end

  end 
end
