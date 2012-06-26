module Alf
  module Tools
    module Registry

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
        raise 'Unable to find a factory'    unless factory
        method_name = Registry.extract_name(factory) unless method_name

        registry.module_eval <<-EOF, __FILE__, __LINE__+1
          self.registered << what
          def self.#{method_name}(*args, &block)
            #{factory}.new(*args, &block)
          end
        EOF
      end

    private

      def self.extract_name(factory)
        Tools.ruby_case(Tools.class_name(factory))
      end

    end # module Registry
  end # module Tools
end # module Alf