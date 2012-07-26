module Alf
  class Adapter
    #
    # Specialization of Adapter to work on files of a given folder.
    #
    # This kind of adapter resolves datasets by simply looking at recognized files in a
    # specific folder. "Recognized" files are simply those for which a Reader subclass has
    # been previously registered. This adapter then serves reader instances.
    #
    class Folder < Adapter

      # (see Adapter.recognizes?)
      #
      # @return [Boolean] true if args contains one String only, which denotes
      #         an existing folder; false otherwise
      def self.recognizes?(conn_spec)
        Path.like?(conn_spec) && Path(conn_spec).directory?
      end

      # (see Adapter#relvar)
      def base_relvar(name)
        if file = find_file(name)
          Relvar::Base.new(self, name){ Reader.reader(file, self) }
        else
          raise NoSuchRelvarError, "No such relvar #{name} (#{@folder})"
        end
      end

      protected

        # Returns the folder on which this adapter works
        def folder
          Path(conn_spec)
        end

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

      Adapter.register(:folder, self)
    end # class Folder
  end # class Adapter
end # module Alf
