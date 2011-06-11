require File.expand_path('../../spec_helper', __FILE__)
class Alf
  describe HashBuffer do
  
    let(:key){ ProjectionKey.new([:a, :b]) }
    let(:buffer){ HashBuffer.new(key) }
    let(:input){[
      {:a => "via_method", :time => 1, :b => "b"},
      {:a => "via_method", :time => 2, :b => "b"},
      {:a => "via_reader", :time => 3, :b => "b"},
    ]}

    before{ buffer.add_all(input) }

    describe "to_h" do
      let(:expected){{
        {:a => "via_method", :b => "b"} => [
          {:a => "via_method", :time => 1, :b => "b"},
          {:a => "via_method", :time => 2, :b => "b"} ],
        {:a => "via_reader", :b => "b"} => [
          {:a => "via_reader", :time => 3, :b => "b"} ] 
      }}
      subject{ buffer.to_h }
      it { should == expected }
    end

  end
end
