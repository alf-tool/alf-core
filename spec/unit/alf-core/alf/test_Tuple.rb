require 'spec_helper'
module Alf
  describe "Tuple" do

    context "when no arg" do
      subject{ Alf::Tuple() }

      it{ should be(Alf::Tuple::EMPTY) }
    end

    context "with an empty Hash" do
      subject{ Alf::Tuple({}) }

      it{ should be(Alf::Tuple::EMPTY) }
    end

    context "with a non-empty Hash" do
      subject{ Alf::Tuple({sid: "S1"}) }

      it{ should be_a(Alf::Tuple) }

      it 'should have expected attributes' do
        subject.to_hash.should eq(sid: "S1")
      end
    end

  end
end
