require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Grouper do
      
    let(:input) {[
      {:a => "via_method", :time => 1},
      {:a => "via_method", :time => 2},
      {:a => "via_reader", :time => 3},
    ]}
    let(:grouper){
      Grouper.new{|g|
        g.attributes = [:time]
        g.as = :as
      }
    }
    subject{ grouper.pipe(input) }

    it "should group as expected" do
      subject.to_a.sort{|k1,k2| k1[:a] <=> k2[:a]}.should == [
        {:a => "via_method", :as => [{:time => 1}, {:time => 2}]},
        {:a => "via_reader", :as => [{:time => 3}]},
      ]
    end

  end 
end
