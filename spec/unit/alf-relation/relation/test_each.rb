require 'spec_helper'
module Alf
  describe "Relation#each" do

    let(:rel){ Relation(:sid => ['S1', 'S2', 'S3']) }

    it 'iterates tuples' do
      count = 0
      rel.each do |t|
        t.should be_a(Tuple)
        count += 1
      end
      count.should eq(3)
    end

    it 'iterates tuples of exact same class' do
      clazz = nil
      rel.each do |t|
        clazz = t.class unless clazz
        t.class.object_id.should eq(clazz.object_id)
      end
    end

  end
end
