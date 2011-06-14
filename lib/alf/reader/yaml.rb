require 'yaml'
class Alf::Reader
  class YAML < Alf::Reader
    
    def each
      case x = with_input_io{|io| ::YAML::load(io)}
      when Array
        x.each(&Proc.new)
      when Hash
        [x].each(&Proc.new)
      else
        raise "Unable to coerce #{x} to a tuple iterator" 
      end
    end
    
    Alf::Reader.register(:yaml, [".yaml"], self)
  end # class YAML
end # class Alf::Reader