require 'spec_helper'
module Alf
  class Adapter
    describe Folder, "an instance" do

      let(:adapter){ Folder.new(Path.dir/"fixtures") }

      let(:readable_cogs){
        [ "suppliers.rash", "suppliers" ]
      }

      it_should_behave_like "an adapter"
      it_should_behave_like "an adapter with readable cogs"

    end # describe Folder
  end # class Adapter
end # module Alf
