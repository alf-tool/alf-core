module Alf
  class Reader
    #
    # Specialization of the Reader contrat for .alf files.
    #
    # A .alf file simply contains a query expression in the Lispy DSL. This
    # reader decodes and compiles the expression and delegates the enumeration
    # to the obtained operator.
    #
    # Note that an Environment must be wired at creation or piping time. 
    # NoSuchDatasetError will certainly occur otherwise.  
    #
    class AlfFile < Reader
      
      # (see Reader#each)
      def each
        op = Alf.lispy(environment).compile(input_text, input_path)
        op.each(&Proc.new)
      end
      
      Reader.register(:alf, [".alf"], self)
    end # module AlfFile
  end # class Reader
end # module Alf
