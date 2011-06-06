require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Ungroup do
      
    let(:input) {[
      {:a => "via_method", :as => [{:time => 1, :b => "b"}, {:time => 2, :b => "b"}]},
      {:a => "via_reader", :as => [{:time => 3, :b => "b"}]},
    ]}
    let(:ungroup){
      Ungroup.new.set_args([:as])
    }
    subject{ ungroup.pipe(input) }

    it "should group as expected" do
      subject.to_a.sort{|k1,k2| k1[:time] <=> k2[:time]}.should == [
        {:a => "via_method", :time => 1, :b => "b"},
        {:a => "via_method", :time => 2, :b => "b"},
        {:a => "via_reader", :time => 3, :b => "b"},
      ]
    end

  end 
end
