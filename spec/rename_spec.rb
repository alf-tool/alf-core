require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Rename do
      
    let(:input) {[
      {:a => "a", :b => "b"},
    ]}
    let(:expected){[
      {:z => "a", :b => "b"},
    ]}

    describe "When used through Lispy" do 
      subject{ renamer.to_a }
      let(:renamer){
        Lispy.rename(input, {:a => :z})
      }
      it{ should == expected }
    end

    describe "When configured as from commandline" do
      subject{ renamer.pipe(input).to_a }
      let(:renamer){
        Rename.new{|g| g.set_args(['a', 'z'])}
      }
      it{ should == expected }
    end

  end 
end
