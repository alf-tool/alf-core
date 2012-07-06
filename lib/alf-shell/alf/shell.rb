require_relative 'shell/doc_manager'
module Alf
  module Shell

    # This is the main documentation extractor
    DOC_EXTRACTOR = DocManager.new

    # Delegator command factory
    def self.Delegator()
      Quickl::Delegator(){|builder|
        builder.doc_extractor = DOC_EXTRACTOR
        builder.class_module Command::ClassMethods
        yield(builder) if block_given?
      }
    end

    # Command factory
    def self.Command()
      Quickl::Command(){|builder|
        builder.command_parent = Alf::Shell::Main
        builder.doc_extractor  = DOC_EXTRACTOR
        builder.class_module Command::ClassMethods
        builder.instance_module Shell::Support
        yield(builder) if block_given?
      }
    end

    # Operator factory
    def self.Operator()
      Quickl::Command(){|builder|
        builder.command_parent = Alf::Shell::Main
        builder.doc_extractor  = DOC_EXTRACTOR
        builder.class_module    Operator::ClassMethods
        builder.instance_module Shell::Support
        builder.instance_module Operator::InstanceMethods
        yield(builder) if block_given?
      }
    end

  end # module Shell
end # module Alf
require_relative 'shell/support'
require_relative 'shell/command'
require_relative 'shell/operator'
