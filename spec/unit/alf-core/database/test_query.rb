require 'spec_helper'
module Alf
  describe Database, 'query' do

    let(:db){ examples_database }

    it 'returns a Relation' do
      db.query{
        project(:suppliers, [:sid])
      }.should be_a(Relation)
    end

  end
end