require 'spec_helper'
module Alf
  class Text::Renderer
    describe Cell do
     
      let(:f){ Cell.new }

      specify "text_rendering" do
        Cell.new(100).text_rendering.should == "100"
        Cell.new(:hello).text_rendering.should == ":hello"
        Cell.new("hello").text_rendering.should == "hello"
        Cell.new(10.0).text_rendering.should == "10.000"
        Cell.new(10/3.0).text_rendering.should == "3.333"
        Cell.new([]).text_rendering.should == "[]"
        Cell.new([10/3.0, true]).text_rendering.should == "[3.333, true]"
        Cell.new(10/3.0, {:float_precision => "%.6f"}).text_rendering.should == "3.333333"
      end

      specify "min_width" do
        Cell.new("").min_width.should == 0
        Cell.new(10/3.0).min_width.should == 5
        Cell.new("12\n5345").min_width.should == 4
      end

      specify "rendering_lines" do
        Cell.new("").rendering_lines.should == []
        Cell.new(10/3.0).rendering_lines.should == ["3.333"]
        Cell.new([10/3.0,true]).rendering_lines.should == ["[3.333, true]"]
        Cell.new("abc").rendering_lines(5).should == ["abc  "]
        Cell.new(12).rendering_lines(5).should == ["   12"]
      end

    end
  end
end
