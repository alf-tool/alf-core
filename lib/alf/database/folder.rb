module Alf
  class Database
    #
    # Specialization of Database to work on files of a given folder.
    #
    # This kind of database resolves datasets by simply looking at recognized files in a
    # specific folder. "Recognized" files are simply those for which a Reader subclass has
    # been previously registered. This database then serves reader instances.
    #
    class Folder < Database

      class << self

        # (see Database.recognizes?)
        #
        # @return [Boolean] true if args contains one String only, which denotes
        #         an existing folder; false otherwise
        def recognizes?(args)
          (args.size == 1) &&
          args.first.is_a?(String) &&
          File.directory?(args.first.to_s)
        end

      end # class << self

      # Creates an database instance, wired to the specified folder.
      #
      # @param [String] folder path to the folder to use as dataset source.
      def initialize(folder)
        @folder = folder
      end

      # (see Database#dataset)
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
      # @return [String] path to an existing file if it exists, nil otherwise.
      def find_file(name)
        if File.file?(explicit = File.join(@folder, name.to_s))
          explicit
        else
          Dir[File.join(@folder, "#{name}.*")].find{|f| File.file?(f)}
        end
      end

      Database.register(:folder, self)
    end # class Folder
  end # class Database
end # module Alf
