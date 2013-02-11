require 'spec_helper'
module Alf
  module Support
    describe CSVUtils::ProcIO do
      include CSVUtils

      it 'works as expected' do
        @seen = nil
        proc_io = CSVUtils::ProcIO.new{|str| @seen = str}
        with_csv(proc_io, row_sep: "\n") do |csv|
          csv << ["Smith", 20, "London"]
        end
        @seen.should eq("Smith,20,London\n")
      end

    end
  end
end