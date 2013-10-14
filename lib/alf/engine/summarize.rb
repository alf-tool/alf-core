module Alf
  module Engine
    module Summarize

      def arguments
        [ by, summarization, allbut ]
      end

    end
  end
end
require_relative 'summarize/cesure'
require_relative 'summarize/hash'
