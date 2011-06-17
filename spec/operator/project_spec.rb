require 'spec_helper'
module Alf
  describe Project do
      
    let(:input) {[
      {:a => "a", :b => "b"},
      {:a => "a", :b => "b"},
    ]}

    subject{ operator.to_a }

    describe "when used without --allbut" do
      let(:expected){[{:a => "a"}]}

      describe "and factored with commandline args" do
        let(:operator){ Project.run(["--", 'a']) }
        before{ operator.pipe(input) }
        it { should == expected } 
      end

      describe "and factored with Lispy" do
        let(:operator){ Lispy.project(input, [:a]) }
        it { should == expected } 
      end

    end # --no-allbut

    describe "when used with --allbut" do
      let(:expected){[{:b => "b"}]}

      describe "and factored with commandline args" do
        let(:operator){ Project.run(['--allbut', '--', 'a']) }
        before{ operator.pipe(input) }
        it { should == expected } 
      end

      describe "and factored with Lispy" do
        let(:operator){ Lispy.allbut(input, [:a]) }
        it { should == expected } 
      end

    end # --allbut
    
    describe "when all is projected" do
      let(:expected){[{}]}
      
      describe "when input is not empty" do
        let(:operator){ Lispy.project(input, []) }
        it { should == expected } 
      end
      
      describe "when input is empty" do
        let(:operator){ Lispy.project([], []) }
        it { should == [] } 
      end
      
    end # all attributes projected

  end 
end
