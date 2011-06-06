require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Group do
      
    let(:input) {[
      {:a => "via_method", :time => 1, :b => "b"},
      {:a => "via_method", :time => 2, :b => "b"},
      {:a => "via_reader", :time => 3, :b => "b"},
    ]}
    let(:group){
      Group.new.set_args([:time, :b, :as])
    }
    subject{ group.pipe(input) }

    it "should group as expected" do
      subject.to_a.sort{|k1,k2| k1[:a] <=> k2[:a]}.should == [
        {:a => "via_method", :as => [{:time => 1, :b => "b"}, {:time => 2, :b => "b"}]},
        {:a => "via_reader", :as => [{:time => 3, :b => "b"}]},
      ]
    end

  end 
end
