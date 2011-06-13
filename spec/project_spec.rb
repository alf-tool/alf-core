require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Defaults do
      
    let(:input) {[
      {:a => "a", :b => "b"},
    ]}

    subject{ operator.to_a }

    describe "When used without --allbut" do
      let(:expected){[{:a => "a"}]}

      describe "when factored with commandline args" do
        let(:operator){ Project.new.set_args(['a']) }
        before{ operator.input = input }
        it { should == expected } 
      end

      describe "when factored with Lispy" do
        let(:operator){ Lispy.project(input, :a) }
        it { should == expected } 
      end

      describe "when factored with Lispy with Array args" do
        let(:operator){ Lispy.project(input, [:a]) }
        it { should == expected } 
      end

    end

    describe "When used with --allbut" do
      let(:expected){[{:b => "b"}]}

      describe "when factored with commandline args" do
        let(:operator){ Project.new{|p| p.allbut = true}.set_args(['a']) }
        before{ operator.input = input }
        it { should == expected } 
      end

      describe "when factored with Lispy" do
        let(:operator){ Lispy.allbut(input, :a) }
        it { should == expected } 
      end

      describe "when factored with Lispy with Array args" do
        let(:operator){ Lispy.allbut(input, [:a]) }
        it { should == expected } 
      end

    end

  end 
end
