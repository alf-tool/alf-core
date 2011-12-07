module Alf
  module Operator::Relational
    class Project < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.option   :allbut,     Boolean,  false, 'Project all but specified attributes?'
      end

      def each(&block)
        op = Engine::Clip.new(input, attributes, allbut)
        op = Engine::Compact.new(op)
        op.each(&block)
      end

    end # class Project
  end # module Operator::Relational
end # module Alf
