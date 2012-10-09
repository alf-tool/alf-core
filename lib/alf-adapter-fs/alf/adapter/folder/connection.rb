module Alf
  class Adapter
    class Folder
      class Connection < Adapter::Connection

        alias :folder :conn_spec

        # Returns true if `name` is known, false otherwise.
        def knows?(name)
          !find_file(name).nil?
        end

        # Returns a cog for `name`
        def cog(name)
          Reader.reader(find_file(name))
        end

      protected

        # Finds a specific file by name
        #
        # @param [String] name the name of a dataset
        # @return [Path] path to an existing file if it exists, nil otherwise.
        def find_file(name)
          if (explicit = folder/name.to_s).file?
            explicit
          else
            folder.glob("#{name}.*").find{|f| f.file?}
          end
        end

      end # class Connection
    end # class Folder
  end # class Adapter
end # module Alf
