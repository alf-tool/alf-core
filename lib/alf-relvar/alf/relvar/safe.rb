module Alf
  module Relvar
    class Safe
      extend Forwardable

      OVERRIDED_METHODS = [ :affect, :insert, :delete, :update, :to_relvar ]

      KEPT_METHODS      = Algebra::Operand.instance_methods(false)\
                        | Relvar.instance_methods(false)\
                        | Lang::ObjectOriented::RenderingMethods.instance_methods(false)\

      DELEGATED_METHODS = KEPT_METHODS - OVERRIDED_METHODS

      def_delegators :"@relvar", *DELEGATED_METHODS

      DEFAULT_OPTIONS = {
        coercions:  false,
        projection: nil,
        allbut:     nil
      }

      def initialize(relvar, options = {})
        @relvar  = relvar
        @options = DEFAULT_OPTIONS.merge(options)
      end
      attr_reader :relvar, :options

      def affect(tuples)
        relvar.affect(safe_insert_tuples(tuples))
      end

      def insert(tuples)
        relvar.insert(safe_insert_tuples(tuples))
      end

      def delete(predicate = Predicate.tautology)
        relvar.delete(safe_delete_predicate(predicate))
      end

      def update(updating, predicate = Predicate.tautology)
        relvar.update(safe_updating(updating), safe_update_predicate(predicate))
      end

      def to_relvar
        self
      end

    protected

      def safe_insert_tuples(tuples)
        tuples = Algebra::Operand
                 .coerce(tuples)
                 .extend(Lang::ObjectOriented::AlgebraMethods)
        tuples = tuples.project(insert_attr_list)
        Engine::Compiler.new.call(tuples)
      end

      def safe_updating(updating)
        safe_insert_tuples(updating).tuple_extract
      end

      def safe_delete_predicate(predicate)
        predicate
      end

      def safe_update_predicate(predicate)
        predicate
      end

      def insert_attr_list
        attr_list = relvar.attr_list
        attr_list = attr_list.project options[:white_list] if options.has_key?(:white_list)
        attr_list = attr_list.allbut  options[:black_list] if options.has_key?(:black_list)
        attr_list
      end

    end # class Safe
  end # module Relvar
end # module Alf
