module Alf
  module Sequel
    class Relvar < Alf::Relvar

    protected

      def compile(context)
        context.with_connection do |c|
          Iterator.new(c[name])
        end
      end

    end # class Relvar
  end # module Sequel
end # module Alf