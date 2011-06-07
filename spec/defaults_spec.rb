require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Defaults do
      
    let(:input) {[
      {:a => nil, :b => "b"},
    ]}

    let(:expected) {[
      {:a => 1, :b => "b", :c => "blue"},
    ]}

    subject{ operator.to_a }

    describe "When factored with Lispy" do 
      let(:operator){ Lispy.defaults(input, :a => 1, :c => "blue") }
      it{ should == expected }
    end

    describe "When factored from commandline args" do
      let(:operator){ Defaults.new.set_args(['a', 1, 'c', "blue"]).pipe(input) }
      it{ should == expected }
    end

  end 
end
