require File.expand_path('../spec_helper', __FILE__)
module Alf
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
      let(:operator){ Lispy.sort(input, [[:first, :asc], [:second, :asc]]) }
      it{ should == expected }
    end

    describe "When factored from commandline args" do
      let(:operator){ Sort.run(["--", "first", "asc", "second", "asc"]) }
      before{ operator.pipe(input) }
      it{ should == expected }
    end

    describe "When used on two args" do 
      let(:operator){ Lispy.sort(input, [[:second, :asc], [:first, :asc]]) }
      let(:expected){[
        {:first => "a", :second => 1,  :third => true},
        {:first => "b", :second => 10, :third => false},
        {:first => "a", :second => 20, :third => true},
      ]}
      it{ should == expected }
    end

    describe "When used on single arg" do 
      let(:operator){ Lispy.sort(input, [[:second, :asc]]) }
      let(:expected){[
        {:first => "a", :second => 1,  :third => true},
        {:first => "b", :second => 10, :third => false},
        {:first => "a", :second => 20, :third => true},
      ]}
      it{ should == expected }
    end

    describe "When used with descending order" do 
      let(:operator){ Lispy.sort(input, [[:second, :desc]]) }
      let(:expected){[
        {:first => "a", :second => 20, :third => true},
        {:first => "b", :second => 10, :third => false},
        {:first => "a", :second => 1,  :third => true},
      ]}
      it{ should == expected }
    end

  end 
end
