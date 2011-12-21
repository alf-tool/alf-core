require 'alf/shell/doc_manager'
module Alf
  module Shell

    # This is the main documentation extractor
    DOC_EXTRACTOR = DocManager.new

    # Delegator command factory
    def self.Delegator() 
      Quickl::Delegator(){|builder|
        builder.doc_extractor = DOC_EXTRACTOR
        yield(builder) if block_given?
      }
    end

    # Command factory
    def self.Command() 
      Quickl::Command(){|builder|
        builder.command_parent = Alf::Shell::Main
        builder.doc_extractor  = DOC_EXTRACTOR
        builder.class_module Command::ClassMethods
        yield(builder) if block_given?
      }
    end

    # Operator factory
    def self.Operator() 
      Quickl::Command(){|builder|
        builder.command_parent = Alf::Shell::Main
        builder.doc_extractor  = DOC_EXTRACTOR
        builder.class_module Operator::ClassMethods
        yield(builder) if block_given?
      }
    end

  end # module Shell
end # module Alf
require 'alf/shell/command'
require 'alf/shell/operator'
