module Alf
  module Engine
    class Hierarchize
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList] Attribute list of the id
      attr_reader :id

      # @return [AttrList] Attribute list for the parent
      attr_reader :parent

      # @return [AttrName] Attribute name for children
      attr_reader :children

      # @return [Class] the type of the children relation
      attr_reader :relation_type

      # @return [Class] the type of the children tuples
      attr_reader :tuple_type

      # Creates a Hierarchize instance
      def initialize(operand, id, parent, children, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @id = id
        @parent = parent
        @children = children
      end

      # (see Cog#each)
      def _each(&block)
        by_id = Hash.new{|h,k| h[k] = {children => nil} }
        operand.each do |tuple|
          tuple = tuple.to_hash
          infer_types(tuple) unless @relation_type

          # extract my key and my parent's key
          tuple_key, parent_key = keys_of(tuple)

          # this will be my tuple
          by_id[tuple_key] = tuple.merge(by_id[tuple_key])

          # add me to my parent unless same tuple
          unless tuple_key==parent_key
            my_tuple = tuple_type.new(by_id[tuple_key])
            by_id[parent_key][children] ||= relation_type.new(Set.new)
            by_id[parent_key][children].send(:reused_instance) << my_tuple
          end
        end

        # Now output tuples that are their own parent
        by_id.each_pair do |k,tuple|
          tuple_key, parent_key = keys_of(tuple)
          tuple[children] ||= relation_type.empty
          yield(tuple) if tuple_key==parent_key
        end
      end

      def to_relation
        tuples = to_set
        relation_type.new(tuples)
      end

    private

      def infer_types(tuple)
        heading = Tuple(tuple).heading
        @relation_type = Relation.type(heading){|r| { children => r } }
        @tuple_type    = Tuple.type(heading){|r| { children => @relation_type } }
      end

      def renamer
        @renamer ||= Renaming.new(Hash[parent.to_a.zip(id.to_a)])
      end

      def keys_of(tuple)
        tuple_key  = id.project_tuple(tuple)
        parent_key = renamer.rename_tuple(parent.project_tuple(tuple))
        [ tuple_key, parent_key ]
      end

    end # class Hierarchize
  end # module Engine
end # module Alf
