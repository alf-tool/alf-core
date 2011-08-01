module Alf
  module Types
    
    Boolean = Myrrha::Boolean
    
    def Boolean.from_argv(argv, opts={})
      raise ArgumentError if argv.size > 1
      Tools.coerce(argv.first, Boolean)
    end
        
  end
end