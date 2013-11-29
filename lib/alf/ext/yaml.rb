module Psych
  module Visitors
    class YAMLTree

      def visit_Alf_Tuple o
        @emitter.start_mapping(nil, nil, true, Psych::Nodes::Mapping::BLOCK)
        o.to_hash.each do |k,v|
          accept k.to_s
          accept v
        end
        @emitter.end_mapping
      end

      def visit_Alf_Relation o
        @emitter.start_sequence(nil, nil, true, Nodes::Sequence::BLOCK)
        o.each { |c| accept c }
        @emitter.end_sequence
      end

      def visit_Alf_Renderer_YAML o
        @emitter.start_sequence(nil, nil, true, Nodes::Sequence::BLOCK)
        o.input.each{|tuple|
          @emitter.start_mapping(nil, nil, true, Psych::Nodes::Mapping::BLOCK)
          tuple.to_hash.each do |k,v|
            accept k.to_s
            accept v
          end
          @emitter.end_mapping
        }
        @emitter.end_sequence
      end

    end
  end
end
