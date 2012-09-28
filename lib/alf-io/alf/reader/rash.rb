module Alf
  class Reader
    #
    # Specialization of the Reader contract for .rash files.
    #
    # A .rash file/stream contains one ruby hash literal on each line. This reader simply
    # decodes each of them in turn with Kernel.eval, providing a state-less reader (that
    # is, tuples are not all loaded in memory at once).
    #
    class Rash < Reader

      # (see Reader#line2tuple)
      def line2tuple(line)
        begin
          h = Kernel.eval(line)
          raise "Tuple expected, got #{h}" unless TupleLike===h
        rescue Exception => ex
          $stderr << "Skipping #{line.strip}: #{ex.message}\n"
          nil
        else
          return h
        end
      end

      Reader.register(:rash, [".rash"], self)
    end # class Rash
  end # class Reader
end # module Alf
