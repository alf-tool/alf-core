$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'alf'

Alf::Lispy.extend(Alf::Lispy)

def rel(*args)
  Alf::Relation.coerce(args)
end

def _(path, file)
  File.expand_path("../#{path}", file)
end

def parse_commandline_args(args)
  args = Kernel.eval "%w{#{args}}"
  result = []
  until args.empty?
    if args.first[0,1] == '"'
      if args.first[-1,1] == '"'
        result << args.shift[1...-1]
      else
        block = [ args.shift[1..-1] ]
        while args.first[-1,1] != '"'
          block << args.shift
        end 
        block << args.shift[0...-1]
        result << block.join(" ")
      end
    else
      result << args.shift
    end  
  end
  result
end

def wlang(str, binding)
  str.gsub(/\$\(([\S]+)\)/){ Kernel.eval($1, binding) }
end

require 'shared/an_operator_class'
require 'shared/a_value'