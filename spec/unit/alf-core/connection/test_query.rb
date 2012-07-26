require 'spec_helper'
module Alf
  describe Connection, 'query' do

    let(:conn){ examples_database }

    it 'returns a Relation' do
      conn.query{
        project(:suppliers, [:sid])
      }.should be_a(Relation)
    end

  end
end