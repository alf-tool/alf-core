require 'spec_helper'
module Alf
  describe Reader::AlfFile do

    let(:io){ StringIO.new(expr) }

    subject{
      Reader::AlfFile.new(io, examples_database).to_set
    }

    describe "on pure functional expressions" do
      let(:expr){ 
        "(restrict suppliers, lambda{status > 20})"
      }
      let(:expected){
        [{:sid=>"S3", :name=>"Blake", :status=>30, :city=>"Paris"},
         {:sid=>"S5", :name=>"Adams", :status=>30, :city=>"Athens"}]        
      }

      it{ should eq(expected.to_set) }
    end

    describe "on impure functional expressions" do
      let(:expr){
        <<-EOF
          xxx = (restrict suppliers, lambda{status > 20})
          (extend xxx, :rev => lambda{ -status })
        EOF
      }
      let(:expected){
        [{:sid=>"S3", :name=>"Blake", :status=>30, :city=>"Paris", :rev=>-30},
         {:sid=>"S5", :name=>"Adams", :status=>30, :city=>"Athens", :rev=>-30}]        
      }

      it{ should eq(expected.to_set) }
    end

  end
end