require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Restrict do
      
    let(:input) {[
      {:tested => 1,  :other => "b"},
      {:tested => 30, :other => "a"},
    ]}

    let(:expected){[
      {:tested => 1,  :other => "b", :big => false},
      {:tested => 30, :other => "a", :big => true},
    ]}

    subject{ operator.to_a }

    describe "When factored with Lispy" do 
      let(:operator){ Lispy.extend(input, :big => lambda{ tested > 10 }) }
      it{ should == expected }
    end

    describe "When factored from commandline args" do
      let(:operator){ Extend.new.set_args(["big", "tested > 10"]) }
      before{ operator.pipe(input) }
      it{ should == expected }
    end

  end 
end
