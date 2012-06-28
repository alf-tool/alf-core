module Alf
  module Sequel
    class Relvar < Alf::Relvar

      def initialize(context, name, dataset=nil)
        super(context, name)
        @dataset   = dataset
        @dataset ||= context.with_connection{|c| c[name]}
      end

      def where(projection)
        with_dataset do |c|
          Relvar.new(context, nil, c.where(projection))
        end
      end

      # Affects the current value of this relation variable.
      def affect(value)
        in_transaction do
          delete
          insert(value)
        end
      end

      # Inserts some tuples inside this relation variable.
      def insert(tuples)
        return insert([tuples]) if tuples.is_a?(Hash)
        with_dataset do |d|
          options = {:return => :primary_key}
          Alf::Relation :id => d.multi_insert(tuples, options)
        end
      end

      # Updates all tuples of this relation variable.
      def update(values)
        with_dataset do |d|
          d.update Tuple(values)
        end
        self
      end

      # Delete all tuples of this relation variable.
      def delete
        with_dataset do |d|
          d.delete
        end
        self
      end

    protected

      def with_dataset
        yield(@dataset)
      end

      def in_transaction(&bl)
        context.with_connection do |c|
          c.transaction(&bl)
        end
      end

      def compile(context)
        with_dataset{|d| Iterator.new(d) }
      end

    end # class Relvar
  end # module Sequel
end # module Alf