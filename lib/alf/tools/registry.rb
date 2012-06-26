module Alf
  module Tools
    module Registry

      def listeners
        @listeners ||= []
      end

      def listen(&listener)
        listeners << listener
      end

      def registered
        @registered ||= []
      end
      alias :all :registered

      def each(&bl)
        registered.each(&bl)
      end

      def register(what, registry)
        method_name, factory = nil, nil
        Array(what).each do |arg|
          method_name ||= arg if arg.is_a?(Symbol)
          factory     ||= arg if arg.is_a?(Class)
        end
        method_name = Registry.extract_name(factory) unless method_name
        registry.module_eval <<-EOF, __FILE__, __LINE__+1
          def self.#{method_name}(*args, &block)
            #{factory}.new(*args, &block)
          end
        EOF
        registry.module_eval do
          registered << what
          listeners.each{|l| l.call(method_name, factory) }
        end
      end

    private

      def self.extract_name(factory)
        Tools.ruby_case(Tools.class_name(factory)).to_sym
      end

    end # module Registry
  end # module Tools
end # module Alf