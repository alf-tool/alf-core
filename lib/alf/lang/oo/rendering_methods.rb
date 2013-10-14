module Alf
  module Lang
    module ObjectOriented
      module RenderingMethods

        def self.def_renderer_method(name, clazz)
          define_method(:"to_#{name}") do |*args|
            options, io = nil
            args.each do |arg|
              options ||= arg if arg.is_a?(Hash)
              io      ||= arg if arg.respond_to?(:<<)
            end
            to_array(options || {}) do |arr|
              io ||= ""
              clazz.new(arr, options).execute(io)
              io
            end
          end
        end

        def to_array(options = {})
          _with_ordering(options) do |o|
            op = Alf::Engine::ToArray.new(to_cog, o)
            block_given? ? yield(op) : op.to_a
          end
        end

        def to_a(options = nil)
          to_array(options || {})
        end

        Renderer.listen do |name,clazz|
          def_renderer_method(name, clazz)
        end

      private

        def _with_ordering(options, &bl)
          case options
          when Array, Ordering
            _with_ordering(:sort => options, &bl)
          when Hash
            ordering = options.delete(:order) || options.delete(:sort)
            ordering = Ordering.coerce(ordering || [])
            yield(ordering)
          else
            ::Kernel.raise "Invalid ordering `#{options}`"
          end
        end

      end # module RenderingMethods
    end # module ObjectOriented
  end # module Lang
end # module Alf
