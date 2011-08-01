module Alf
  module Logs
        
    #
    # Implements Alf::Reader contract for reading log files.
    #
    class Reader < Alf::Reader
      
      DEFAULT_OPTIONS = {
        :file_format => nil,
        :line_def    => :access
      }
      
      attr_reader :options
      
      def initialize(*args)
        Alf::Tools::friendly_require('request_log_analyzer')
        super(*args)
        @options[:file_format] = coerce_file_format(@options[:file_format])
      end
      
      def each
        parser = infer_parser(input_path)
        with_input_io do |io|
          parser.parse_stream(io) do |req|
            yield request_to_tuple(req)
          end
        end
      end
      
      private
      
      def coerce_file_format(file_format)
        case file_format
        when NilClass
          nil
        when RequestLogAnalyzer::FileFormat
          file_format
        when Symbol
          RequestLogAnalyzer::FileFormat.load(file_format)
        when Array
          RequestLogAnalyzer::FileFormat.load(*file_format)
        else 
          raise ArgumentError, "Invalid file format: #{file_format}"
        end
      end
      
      def infer_parser(path)
        file_format = @options[:file_format] || begin
          unless path
            raise NotImplementedError, "Logs::Reader does not work on IO for now"
          end
          RequestLogAnalyzer::FileFormat.autodetect(path)
        end
        RequestLogAnalyzer::Source::LogParser.new(file_format)
      end
      
      def request_to_tuple(req)
        req.attributes
      end
      
      LOG_TYPES = {
        # RequestLogAnalyzer::Request::Converters
        :string          => String,
        :float           => Float,
        :decimal         => Float,
        :int             => Integer,
        :integer         => Integer,
        :sym             => Symbol,
        :symbol          => Symbol,
        :timestamp       => Integer,
        :traffic         => Integer,
        :duration        => Float,
        :epoch           => Integer,
        # AmazonS3
        :nillable_string => String,
        :referer         => String,
        :user_agent      => String,
        # Apache
        :path            => String,
        # MySQL
        :sql             => String
      }
      
      def infer_heading(format, line_def = :access)
        h = Hash[format.line_definitions[line_def].captures.collect{|capt|
          [ capt[:name], to_type(capt[:type]) ]
        }]
        Alf::Heading.new(h)
      end
      
      def to_type(log_type)
        LOG_TYPES[log_type] || String
      end
      
      ::Alf::Reader.register(:logs, [".log"], self)
    end # class Reader
    
  end # module Logs
end # module Alf