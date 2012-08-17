module Alf
  module CSV
    module Version

      MAJOR = 0
      MINOR = 13
      TINY  = 0

      def self.to_s
        [ MAJOR, MINOR, TINY ].join('.')
      end

    end
    VERSION = Version.to_s
  end
end