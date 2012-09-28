require 'spec_helper'
module Alf
  describe Heading, "#coerce" do

    let(:tuple)  { Tuple[:id => 3, :name => "Alf"] }
    let(:heading){ Heading[:id => Integer, :name => String] }

    context 'on a Hash' do
      subject{ heading.coerce("id" => "3", "name" => "Alf") }

      it { should eq(tuple) }
    end

    context 'on an Array' do
      subject{ heading.coerce([{"id" => "3", "name" => "Alf"}]) }

      it { should eq([tuple]) }
    end

  end
end