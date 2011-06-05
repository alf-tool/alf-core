require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Nest do
      
    let(:input) {[
      {:a => "a", :b => "b", :c => "c"},
    ]}
    subject{ nest.pipe(input) }

    let(:nest){
      Nest.new.set_args ["a", "b", "nested"]
    }

    it "should group as expected" do
      subject.to_a.should == [
        {:nested => {:a => "a", :b => "b"}, :c => "c"}
      ]
    end

  end 
end
