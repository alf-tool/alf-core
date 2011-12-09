module Alf
  module Iterator
    class Proxy
      include Iterator

      # @return [Symbol] name of the dataset to request to environment
      attr_reader :name

      # Creates a proxy instance.
      #
      # @param [Environment] env the environment serving iterator instances
      # @param [Symbol] dataset named dataset to rely on
      def initialize(env, name)
        unless env.respond_to?(:dataset)
          raise ArgumentError, "Invalid environment #{env.inspect}"
        end
        @environment, @name = env, name
      end

      # (see Iterator#each)
      def each(&block)
        @environment.dataset(@name).each(&block)
      end

    end # class Proxy
  end # module Iterator
end # module Alf
