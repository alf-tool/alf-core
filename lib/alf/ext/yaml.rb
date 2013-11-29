module Psych
  module Visitors
    class YAMLTree

      def visit_Alf_Tuple o
        tag      = nil
        implicit = !tag

        register(o, @emitter.start_mapping(nil, tag, implicit, Psych::Nodes::Mapping::BLOCK))

        o.to_hash(false).each do |k,v|
          accept k.to_s
          accept v
        end

        @emitter.end_mapping
      end

      def visit_Alf_Relation o
        register o, @emitter.start_sequence(nil, nil, true, Nodes::Sequence::BLOCK)
        o.each { |c| accept c }
        @emitter.end_sequence
      end

    end
  end
end
