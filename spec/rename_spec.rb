require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Rename do
      
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
      let(:operator){ Rename.new.set_args(['a', 'z']) }
      before{ operator.pipe(input) }
      it{ should == expected }
    end

  end 
end
