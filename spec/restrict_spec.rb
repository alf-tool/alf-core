require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Restrict do
      
    let(:input) {[
      {:tested => 1, :other => "b"},
      {:tested => 30, :other => "a"},
    ]}
    subject{ restrict.pipe(input) }

    describe "when used with no argument" do
      let(:restrict){
        Restrict.new.set_args []
      }
      it "should restrict as expected" do
        subject.to_a.should == input
      end
    end

    describe "when used with a string" do
      let(:restrict){
        Restrict.new.set_args ["tested < 10"]
      }
      it "should restrict as expected" do
        subject.to_a.should == [
          {:tested => 1, :other => "b"}
        ]
      end
    end

    describe "when used with arguments" do
      let(:restrict){
        Restrict.new.set_args ["tested", 1]
      }
      it "should restrict as expected" do
        subject.to_a.should == [
          {:tested => 1, :other => "b"}
        ]
      end
    end

  end 
end
