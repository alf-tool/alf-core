module Alf
  module Operator::NonRelational
    class Clip < Alf::Operator()
      include NonRelational, Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.option   :allbut,     Boolean, false, "Apply an allbut clipping?"
      end

      def each(&block)
        Engine::Clip.new(input, attributes, allbut).each(&block)
      end

    end # class Clip
  end # module Operator::NonRelational
end # module Alf
