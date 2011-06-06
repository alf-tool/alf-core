require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Restrict do
      
    let(:input) {[
      {:tested => 1, :other => "b"},
      {:tested => 30, :other => "a"},
    ]}
    subject{ restrict.pipe(input) }

    let(:restrict){
      Restrict.new.set_args ["tested < 10"]
    }

    it "should restrict as expected" do
      subject.to_a.should == [
        {:tested => 1, :other => "b"}
      ]
    end

  end 
end
