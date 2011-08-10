module Alf
  module Iterator
    class Proxy
      include Iterator

      #
      # Creates a proxy instance.
      #
      # @param [Environment] env the environment serving iterator instances
      # @param [Symbol] dataset named dataset to rely on
      #
      def initialize(env, dataset)
        @environment, @dataset = env, dataset
      end

      # (see Iterator#pipe)
      def pipe(input, environment = nil)
        @environment ||= environment 
        @dataset ||= input
        self
      end

      # (see Iterator#each)
      def each(&block)
        @environment.dataset(@dataset).each(&block)
      end

    end # class Proxy
  end # module Iterator
end # module Alf
