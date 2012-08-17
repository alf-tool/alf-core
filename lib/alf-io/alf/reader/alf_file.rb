module Alf
  class Reader
    #
    # Specialization of the Reader contract for .alf files.
    #
    # A .alf file simply contains a query expression in the Lispy DSL. This reader decodes
    # and compiles the expression and delegates the enumeration to the obtained operator.
    #
    # Note that a connection must be wired at creation time. A NoSuchRelvarError will
    # certainly occur otherwise.
    #
    class AlfFile < Reader

      # (see Reader#each)
      def each
        context.query(input_text, input_path).each(&Proc.new)
      end

      Reader.register(:alf, [".alf"], self)
    end # module AlfFile
  end # class Reader
end # module Alf
