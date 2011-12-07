module Alf
  class Environment
    #
    # This methods provides base methods for implementing the Environment 
    # contract. The Environment class already includes it and should be used
    # as a superclass of specific implementations.
    #
    module InstanceMethods

      # Returns a dataset whose name is provided.
      #
      # This method resolves named datasets to tuple enumerables. When the 
      # dataset exists, this method must return an Iterator, typically a 
      # Reader instance. Otherwise, it must throw a NoSuchDatasetError.
      #
      # @param [Symbol] name the name of a dataset
      # @return [Iterator] an iterator, typically a Reader instance
      # @raise [NoSuchDatasetError] when the dataset does not exists
      def dataset(name)
      end
      undef :dataset

    end # module InstanceMethods
    include(InstanceMethods)
  end # class Environment
end # module Alf
