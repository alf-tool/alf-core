require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Rename do
      
    let(:input) {[
      {:a => "a", :b => "b"},
    ]}
    subject{ renamer.pipe(input) }

    describe "When used through API" do 

      let(:renamer){
        Rename.new{|g| g.renaming = {:a => :z}}
      }

      it "should group as expected" do
        subject.to_a.should == [
          {:z => "a", :b => "b"},
        ]
      end

    end

    describe "When configured as from commandline" do

      let(:renamer){
        Rename.new{|g| g.set_args(['a', 'z'])}
      }

      it "should group as expected" do
        subject.to_a.should == [
          {:z => "a", :b => "b"},
        ]
      end

    end

  end 
end
