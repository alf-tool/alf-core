module Alf
  #
  # Implements an Iterator at the interface with the outside world.
  #
  # The contrat of a Reader is simply to be an Iterator. Unlike operators, 
  # however, readers are not expected to take other iterators as input, but IO 
  # objects, database tables, or something similar instead. This base class 
  # provides a default behavior for readers that works with IO objects. It can 
  # be safely extended, overriden, or even mimiced (provided that you include 
  # and implement the Iterator contract).
  #
  # This class also provides a registration mechanism to help getting Reader 
  # instances for specific file extensions. A typical scenario for using this
  # registration mechanism is as follows:
  #
  #   # Registers a reader kind named :foo, associated with ".foo" file 
  #   # extensions and the FooFileDecoder class (typically a subclass of 
  #   # Reader)
  #   Reader.register(:foo, [".foo"], FooFileDecoder)   
  #
  #   # Later on, you can request a reader instance for a .foo file, as 
  #   # illustrated below.  
  #   r = Reader.reader('/a/path/to/a/file.foo')
  #
  #   # Also, a factory method is automatically installed on the Reader class
  #   # itself. This factory method can be used with a String, or an IO object.
  #   r = Reader.foo([a path or a IO object])
  #
  class Reader
    include Iterator

    require 'alf/reader/class_methods'
    require 'alf/reader/base'
    require 'alf/reader/rash'
    require 'alf/reader/alf_file'
  end # class Reader
end # module Alf
