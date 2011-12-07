module Alf
  module Operator::NonRelational
    class Generator < Alf::Operator()
      include Operator::NonRelational, Operator::Nullary

      signature do |s|
        s.argument :size, Size, 10
        s.argument :as,   AttrName, :num
      end
          
      protected

      def _each
        size.times do |i|
          yield(@as => i+1)
        end
      end

    end # class Generator
  end # module Operator::NonRelational
end # module Alf
