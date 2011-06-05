require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Unnest do
      
    let(:input) {[
      {:nested => {:a => "a", :b => "b"}, :c => "c"}
    ]}
    subject{ unnest.pipe(input) }

    let(:unnest){
      Unnest.new.set_args ["nested"]
    }

    it "should group as expected" do
      subject.to_a.should == [
        {:a => "a", :b => "b", :c => "c"},
      ]
    end

  end 
end
