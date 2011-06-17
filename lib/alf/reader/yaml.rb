require 'yaml'
class Alf::Reader
  class YAML < Alf::Reader
    include Alf::Tools
    
    def each
      x = with_input_io{|io| ::YAML::load(io)}
      x = [x] if x.is_a?(Hash)
      x.each{|tuple| yield(normalize(tuple))}
    end

    private
    
    def normalize(tuple)
      case tuple
      when Hash
        tuple_collect(tuple) do |k,v|
          [k.to_s.to_sym, normalize(v)]
        end
      when Array
        tuple.collect{|x| normalize(x)}
      else 
        tuple
      end
    end
    
    Alf::Reader.register(:yaml, [".yaml"], self)
  end # class YAML
end # class Alf::Reader