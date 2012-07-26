module Alf
  module Operator
    module NonRelational
      class Clip
        include Operator, NonRelational, Unary

        signature do |s|
          s.argument :attributes, AttrList, []
          s.option   :allbut,     Boolean, false, "Apply an allbut clipping?"
        end

        def heading
          @heading ||= operand.heading.project(attributes, allbut)
        end

        def keys
          @keys ||= begin
            keys = operand.keys
            keys = keys.map{|k| k.project(attributes, allbut) }
            keys = keys.reject!{|k| k.empty? }
            keys = [ heading.to_attr_list.project(attributes, allbut) ] if keys.empty?
            keys.freeze
          end
        end

      end # class Clip
    end # module NonRelational
  end # module Operator
end # module Alf
