module Alf
  module Operator::Relational
    class Group < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.argument :as,         AttrName, :group
        s.option   :allbut,     Boolean,  false, 'Group all but specified attributes?'
      end

      # (see Operator#each)
      def each(&block)
        Engine::Group::Hash.new(input, attributes, as, allbut).each(&block)
      end
  
    end # class Group
  end # module Operator::Relational
end # module Alf
