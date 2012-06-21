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
      def self.recognizes?(args)
        return false unless (args.size == 1)
        Tools.pathable?(args.first) && Tools.to_path(args.first).directory?
      end

      # Creates an adapter instance, wired to the specified folder.
      #
      # @param [String] folder path to the folder to use as dataset source.
      def initialize(folder)
        @folder = Tools.to_path(folder)
      end

      # (see Adapter#dataset)
      def dataset(name)
        if file = find_file(name)
          Reader.reader(file, self)
        else
          raise NoSuchDatasetError, "No such dataset #{name} (#{@folder})"
        end
      end

      protected

        # Finds a specific file by name
        #
        # @param [String] name the name of a dataset
        # @return [Path] path to an existing file if it exists, nil otherwise.
        def find_file(name)
          if (explicit = @folder/name.to_s).file?
            explicit
          else
            @folder.glob("#{name}.*").find{|f| f.file?}
          end
        end

      Adapter.register(:folder, self)
    end # class Folder
  end # class Adapter
end # module Alf
