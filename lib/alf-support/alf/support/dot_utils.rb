module Alf
  module Support
    module DotUtils

      def dot_label(label, strip = 100)
        label = label.to_s[0..strip]
                     .gsub(/"/, '\"')
                     .gsub(/\n/, '\n')
                     .gsub(">", "&gt;")
        %Q{"#{label}"}
      end

    end # module DotUtils
  end # module Support
end # module Alf
