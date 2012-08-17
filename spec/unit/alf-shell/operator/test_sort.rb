require 'spec_helper'
module Alf::Shell::Operator
  describe Sort do

    let(:input){ suppliers }
    subject{ Sort.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Sort)
      subject.operands.should eq([input])
    end

    context "with empty args" do
      let(:argv){ [input] + %w{} }
      specify{
        subject.ordering.should eq(Alf::Ordering.new([]))
      }
    end

    context "with one arg" do
      let(:argv){ [input] + %w{-- name} }
      specify{
        subject.ordering.should eq(Alf::Ordering[[:name, :asc]])
      }
    end

    context "with two args" do
      let(:argv){ [input] + %w{-- first last} }
      specify{
        subject.ordering.should eq(Alf::Ordering[[[:first, :asc], [:last, :asc]]])
      }
    end

    context "with explicit ordering" do
      let(:argv){ [input] + %w{-- first desc} }
      specify{
        subject.ordering.should eq(Alf::Ordering[[[:first, :desc]]])
      }
    end

    context "with explicit ordering on multiple" do
      let(:argv){ [input] + %w{-- first desc last asc} }
      specify{
        subject.ordering.should eq(Alf::Ordering[[[:first, :desc], [:last, :asc]]])
      }
    end

  end
end
