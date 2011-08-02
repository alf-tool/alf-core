module Alf
  module Operator::Relational
    # 
    # Relational join (and cross-join)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   (join :suppliers, :parts)
    #
    # DESCRIPTION
    #
    # This operator computes the (natural) join of two input iterators. Natural
    # join means that, unlike what is commonly used in SQL, the default behavior 
    # is to join on common attributes. You can use the rename operator if this
    # behavior does not fit your needs.
    #
    #   alf join suppliers supplies 
    #  
    class Join < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature do |s|
      end
      
      #
      # Performs a Join of two relations through a Hash buffer on the right
      # one.
      #
      class HashBased
        include Operator, Operator::Binary
      
        #
        # Implements a special Buffer for join-based relational operators.
        #
        # Example:
        #
        #   buffer = Buffer::Join.new(...) # pass the right part of the join
        #   left.each do |left_tuple|
        #     key, rest = buffer.split(tuple)
        #     buffer.each(key) do |right_tuple|
        #       #
        #       # do whatever you want with left and right tuples
        #       #
        #     end
        #   end 
        #
        class JoinBuffer
          include Tools
          
          #
          # Creates a buffer instance with the right part of the join.
          #
          # @param [Iterator] enum a tuple iterator, right part of the join. 
          #
          def initialize(enum)
            @buffer = nil
            @key = nil
            @enum = enum
          end
          
          #
          # Splits a left tuple according to the common key.
          #
          # @param [Hash] tuple a left tuple of the join
          # @return [Array] an array of two elements, the key and the rest
          # @see AttrList#split
          #
          def split(tuple)
            _init(tuple) unless @key
            @key.split(tuple)
          end
          
          #
          # Yields each right tuple that matches a given key value.
          #
          # @param [Hash] key a tuple that matches elements of the common key
          #        (typically the first element returned by #split) 
          #
          def each(key)
            @buffer[key].each(&Proc.new) if @buffer.has_key?(key)
          end
          
          private
          
          # Initialize the buffer with a right tuple
          def _init(right)
            @buffer = Hash.new{|h,k| h[k] = []}
            @enum.each do |left|
              @key ||= coerce(left.keys & right.keys, AttrList)
              @buffer[@key.project(left)] << left
            end
            @key ||= coerce([], AttrList)
          end
          
        end # class JoinBuffer
        
        protected
        
        # (see Operator#_each)
        def _each
          buffer = JoinBuffer.new(right)
          left.each do |left_tuple|
            key, rest = buffer.split(left_tuple)
            buffer.each(key) do |right|
              yield(left_tuple.merge(right))
            end
          end
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Join
  end # module Operator::Relational
end # module Alf
