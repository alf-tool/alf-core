require File.expand_path('../../../spec_helper', __FILE__)
class Alf
  class Renderer::Plot
    describe "to_plot" do

      let(:data)    { [ {:x => 1, :y => 10}, {:x => 2, :y => 20} ] }

      let(:dataset) { {:title => "serie", :linewidth => 4, :data =>  data } }

      let(:plot)    { {:title => "plot", :datasets => [ dataset ] } }

      subject{ Renderer::Plot.to_plot(plot) }

      it "should return a correct plot instance" do
        subject.is_a?(Gnuplot::Plot).should be_true
        subject["title"].should == '"plot"'
      end

    end
  end  
end
