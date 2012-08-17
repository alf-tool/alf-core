module Alf
  describe Heading, "merge" do

    subject{ left.merge(right) }

    context 'with disjoint headings' do
      let(:left) { Heading[:name => String] }
      let(:right){ Heading[:city => String] }

      it "computes the union" do
        subject.should eq(Heading[:name => String, :city => String])
      end
    end

    context 'with non disjoint headings' do
      let(:left) { Heading[:id => Integer, :name => String] }
      let(:right){ Heading[:id => Integer, :name => Integer] }

      it "computes uses right on commons" do
        subject.should eq(Heading[:id => Integer, :name => Integer])
      end
    end

  end
end
