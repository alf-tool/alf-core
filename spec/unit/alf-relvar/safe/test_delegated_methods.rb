require 'spec_helper'
module Alf
  module Relvar
    describe Safe, "DELEGATED_METHODS" do

      subject{ Safe::DELEGATED_METHODS.to_set }

      let(:expected){
        [ :heading, :attr_list, :keys, :type, 
          :empty?, :empty!, :not_empty!, :value, 
          :lock, :safe,
          :to_lispy, 
          :each, :to_relation, :to_cog, :to_array, :to_a, 
          :to_rash, :to_text, :to_yaml, :to_json, :to_csv ].to_set
      }

      it{ should eq(expected) }

    end
  end
end
