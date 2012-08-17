require 'spec_helper'
module Alf
  describe Heading, "coerce" do

    let(:heading){ Heading[:id => Integer, :name => String] }

    context 'on a Hash' do
      subject{ heading.coerce("id" => "3", "name" => "Alf") }

      it { should eq(:id => 3, :name => "Alf") }
    end

    context 'on an Array' do
      subject{ heading.coerce([{"id" => "3", "name" => "Alf"}]) }

      it { should eq([{:id => 3, :name => "Alf"}]) }
    end

  end
end
