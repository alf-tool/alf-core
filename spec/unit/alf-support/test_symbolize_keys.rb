require 'spec_helper'
module Alf
  describe Support, 'symbolize_keys' do
    include Support

    subject{ symbolize_keys(arg) }

    context 'with an empty Hash' do
      let(:arg){ Hash.new }
      it { should eq({}) }
    end

    context 'with a Hash with all symbols already' do
      let(:arg){ {:name => "Jones", :id => 2} }
      it { should eq(arg) }
    end

    context 'with a Hash with String keys' do
      let(:arg){ {"name" => "Jones", "id" => 2} }
      it { should eq({:name => "Jones", :id => 2}) }
    end
    
  end
end