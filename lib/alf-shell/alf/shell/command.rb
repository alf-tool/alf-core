module Alf
  module Command
    module ClassMethods

      # Returns the ruby case name of this operator
      def rubycase_name 
        Tools.ruby_case(Tools.class_name(self))
      end

      # @return true
      def command?
        true
      end
    
      # @return false
      def operator?
        false
      end
    
    end # module ClassMethods
  end # module Command
end # module Alf
require 'alf/shell/command/main'
require 'alf/shell/command/exec'
require 'alf/shell/command/help'
require 'alf/shell/command/show'
