require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Defaults do
      
    let(:input) {[
      {:a => nil, :b => "b"},
    ]}
    subject{ defs.pipe(input) }

    let(:defs){
      Defaults.new.set_args(['a', 1, 'c', "blue"])
    }

    it "should group as expected" do
      subject.to_a.should == [
        {:a => 1, :b => "b", :c => "blue"},
      ]
    end

  end 
end
