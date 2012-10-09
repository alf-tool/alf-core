module Alf
  class Adapter
    class Folder < Adapter

      # (see Connection.recognizes?)
      #
      # @return [Boolean] true if args contains one String only, which denotes
      #         an existing folder; false otherwise
      def self.recognizes?(conn_spec)
        Path.like?(conn_spec) && Path(conn_spec).directory?
      end

      # Returns a connection on the underlying folder
      def connection
        Folder::Connection.new(Path(conn_spec))
      end

      Adapter.register(:folder, self)
    end # class Folder
  end # class Adapter
end # module Alf
require_relative 'folder/connection'