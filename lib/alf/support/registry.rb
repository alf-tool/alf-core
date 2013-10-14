module Alf
  module Support
    module Registry

      def listeners
        @listeners ||= []
      end

      def listen(&listener)
        listeners << listener
        registered.each do |what|
          method_name, factory = Registry.decode_registered(what)
          listener.call(method_name, factory)
        end
      end

      def registered
        @registered ||= []
      end
      alias :all :registered

      def each(&bl)
        registered.each(&bl)
      end

      def register(what, registry)
        method_name, factory = Registry.decode_registered(what)
        (class << registry; self; end).
          send(:define_method, method_name) do |*args, &block|
            factory.new(*args, &block)
          end
        registry.module_eval do
          registered << what
          listeners.each{|l| l.call(method_name, factory) }
        end
      end

    private

      def self.decode_registered(what)
        method_name, factory = nil, nil
        Array(what).each do |arg|
          method_name ||= arg if arg.is_a?(Symbol)
          factory     ||= arg if arg.is_a?(Class)
        end
        method_name = Support.rubycase_name(factory) unless method_name
        [method_name, factory]
      end

    end # module Registry
  end # module Support
end # module Alf