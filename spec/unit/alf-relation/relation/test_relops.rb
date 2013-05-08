require 'spec_helper'
module Alf
  describe Relation do

    let(:rel1){Alf::Relation(sid: ['S1', 'S2', 'S3']) }
    let(:rel2){Alf::Relation(sid: ['S5', 'S2'])       }

    it 'should have all relational operators installed' do
      Algebra::Operator.each do |op|
        rel1.should respond_to(op.rubycase_name)
      end
    end

    specify "project" do
      rel1.project([]).should eq(Alf::Relation::DEE)
      rel1.project([:sid], allbut: true).should eq(Alf::Relation::DEE)
    end

    specify "allbut" do
      rel1.allbut([:sid]).should eq(Alf::Relation::DEE)
    end

    specify "extend" do
      rel1.extend(x: lambda{ sid.downcase }).should == Alf::Relation([
        {sid: 'S1', x: 's1'},
        {sid: 'S2', x: 's2'},
        {sid: 'S3', x: 's3'}
      ])
    end

    specify "union" do
      (rel1 + rel1).should == rel1
      (rel1 | rel1).should == rel1
      (rel1 + rel2).should == Alf::Relation(sid: ['S1','S3','S2','S5'])
    end # union

    specify "difference" do
      (rel1 - rel1).should == Alf::Relation::DUM
      (rel1 - rel2).should == Alf::Relation(sid: ['S1', 'S3'])
      (rel2 - rel1).should == Alf::Relation(sid: 'S5')
    end # difference

    specify "join" do
      (rel1 * rel2).should == Alf::Relation(sid: 'S2')
      (rel2 * rel1).should == Alf::Relation(sid: 'S2')
    end # join

    specify "intersect" do
      (rel1 & rel2).should == Alf::Relation(sid: 'S2')
      (rel2 & rel1).should == Alf::Relation(sid: 'S2')
    end # intersect

    specify "matching" do
      (rel1 =~ rel2).should == Alf::Relation(sid: 'S2')
    end # intersect

    specify "not matching" do
      (rel1 !~ rel2).should == Alf::Relation(sid: ['S1', 'S3'])
    end # intersect

  end
end
