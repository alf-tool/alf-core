module Alf
  module Engine
    #
    # Provides hash-based grouping.
    #
    class Image::Hash
      include Image
      include Cog

      # @return [Enumerable] The left operand
      attr_reader :left

      # @return [Enumerable] The right operand
      attr_reader :right

      # @return [AttrName] Name of the new attribute
      attr_reader :as

      # Creates a Image::Hash instance
      def initialize(left, right, as, expr = nil, compiler = nil)
        super(expr, compiler)
        @left = left
        @right = right
        @as = as
      end

      def each(&block)
        return to_enum unless block
        dup._each(&block)
      end

      # (see Cog#each)
      def _each(&block)
        key_attrs, type, images = nil, nil, nil
        left.each do |left_tuple|
          unless key_attrs
            key_attrs, type, images = build_index(left_tuple, right)
          end
          key = key_attrs.project_tuple(left_tuple)
          yield left_tuple.merge(@as => type.new(images[key]))
        end
      end

      def arguments
        [ as ]
      end

      def options
        {}
      end

    private

      def build_index(left_witness, right)
        infer_type, heading = !image_type, Alf::Heading::EMPTY
        images = ::Hash.new{|h,k| h[k] = ::Set.new }
        key_attrs = nil
        right.each do |right_witness|
          key_attrs ||= AttrList.new(left_witness.keys & right_witness.keys)
          key, image = key_attrs.split_tuple(right_witness)
          images[key] << image
          heading += Heading.infer(image) if infer_type
        end
        [ key_attrs || AttrList::EMPTY, image_type || Relation[heading], images ]
      end

      def image_type
        @image_type ||= expr && Relation[expr.heading[as]]
      rescue NotSupportedError
        nil
      end

    end # class Image::Hash
  end # module Engine
end # module Alf
