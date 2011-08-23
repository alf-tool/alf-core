module Alf
  class Environment
    #
    # Specialization of Environment to work on files of a given folder.
    #
    # This kind of environment resolves datasets by simply looking at 
    # recognized files in a specific folder. "Recognized" files are simply
    # those for which a Reader subclass has been previously registered.
    # This environment then serves reader instances.
    #
    class Folder < Environment
      
      # 
      # (see Environment.recognizes?)
      #
      # Returns true if args contains onely a String which is an existing
      # folder.
      #
      def self.recognizes?(args)
        (args.size == 1) && 
        args.first.is_a?(String) && 
        File.directory?(args.first.to_s)
      end
      
      #
      # Creates an environment instance, wired to the specified folder.
      #
      # @param [String] folder path to the folder to use as dataset source
      #
      def initialize(folder)
        @folder = folder
      end
      
      # (see Environment#dataset)
      def dataset(name)
        if file = find_file(name)
          Reader.reader(file, self)
        else
          raise NoSuchDatasetError, "No such dataset #{name} (#{@folder})"
        end
      end
      
      protected
      
      def find_file(name)
        # TODO: refactor this, because it allows getting out of the folder
        if File.exists?(name.to_s)
          name.to_s
        elsif File.exists?(explicit = File.join(@folder, name.to_s)) &&
              File.file?(explicit)
          explicit
        else
          Dir[File.join(@folder, "#{name}.*")].find do |f|
            File.file?(f)
          end
        end
      end
      
      Environment.register(:folder, self)
    end # class Folder
  end # class Environment
end # module Alf
