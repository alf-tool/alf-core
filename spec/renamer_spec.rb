require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Renamer do
      
    let(:input) {[
      {:a => "a", :b => "b"},
    ]}
    let(:renamer){
      Renamer.new{|g|
        g.renaming = {:a => :z}
      }
    }
    subject{ renamer.pipe(input) }

    it "should group as expected" do
      subject.to_a.should == [
        {:z => "a", :b => "b"},
      ]
    end

  end 
end
