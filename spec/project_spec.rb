require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Defaults do
      
    let(:input) {[
      {:a => "a", :b => "b"},
    ]}
    subject{ proj.pipe(input) }

    describe "When used without --allbut" do
      let(:proj){
        Project.new.set_args(['a'])
      }

      it "should group as expected" do
        subject.to_a.should == [
          {:a => "a"}
        ]
      end
    end

    describe "When used without --allbut" do
      let(:proj){
        Project.new{|p| p.allbut = true; p.set_args(['a'])}
      }

      it "should group as expected" do
        subject.to_a.should == [
          {:b => "b"}
        ]
      end
    end

  end 
end
