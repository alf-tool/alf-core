module Alf
  module Types
    class Keys
      extend Forwardable

      attr_reader :keys

      def initialize(keys)
        @keys = keys.freeze
      end

      class << self

        def coerce(arg)
          case arg
          when Keys  then arg
          when Array then Keys.new arg.map{|k| AttrList.coerce(k)}
          else
            raise ArgumentError, "Unable to coerce `arg` to keys"
          end
        end

        def [](*args)
          coerce(args)
        end

      end # class << self

      def_delegators :keys, :empty?, 
                            :each,
                            :any?,
                            :all?

      def +(other)
        Keys.new (keys + Keys.coerce(other).keys).uniq
      end

      def &(other)
        Keys.new (keys & Keys.coerce(other).keys)
      end

      [ :select, :reject, :map ].each do |m|
        define_method(m) do |*args, &bl|
          Keys.new keys.send(m, *args, &bl).uniq
        end
      end

      def first
        keys.first
      end

      def if_empty(keys = nil, &bl)
        return self unless empty?
        Keys.coerce(keys || bl.call)
      end

      def project(attributes, allbut = false)
        map{|k| k.project(attributes, allbut) }
      end

      def rename(renaming)
        renaming = Renaming.coerce(renaming)
        map{|k| renaming.rename_attr_list(k) }
      end

      def compact
        reject{|k| k.empty? }
      end

      def ==(other)
        other.is_a?(Keys) and (other.keys.to_set == keys.to_set)
      end

      def hash
        keys.to_set.hash
      end

      EMPTY = Keys.new([])
    end # class Keys
  end # module Types
end # module Alf