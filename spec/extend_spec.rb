require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Restrict do
      
    let(:input) {[
      {:tested => 1,  :other => "b"},
      {:tested => 30, :other => "a"},
    ]}
    subject{ extend.pipe(input) }

    let(:extend){
      Extend.new.set_args ["big", "tested > 10"]
    }

    it "should extend as expected" do
      subject.to_a.should == [
        {:tested => 1,  :other => "b", :big => false},
        {:tested => 30, :other => "a", :big => true},
      ]
    end

  end 
end
