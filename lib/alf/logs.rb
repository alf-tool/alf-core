module Alf
  module Logs
    
    #
    # Provides common tooling to Logs renderer and readers
    #
    module Commons

    end # module Commons
        
    #
    # Implements Alf::Reader contract for reading log files.
    #
    class Reader < Alf::Reader
      include Logs::Commons
      
      attr_reader :file_format
      
      def initialize(input = nil, env = nil, file_format = [:apache, :combined], line_def = :access)
        super(input, env)
        Alf::Tools::friendly_require('request_log_analyzer')
        @file_format = case file_format
        when RequestLogAnalyzer::FileFormat
        when Symbol
          file_format = RequestLogAnalyzer::FileFormat.load(file_format)
        when Array
          file_format = RequestLogAnalyzer::FileFormat.load(*file_format)
        else 
          raise ArgumentError, "Invalid file format: #{file_format}"
        end
        @line_def = line_def
        @heading = infer_heading(@file_format, @line_def)
      end
      
      def each
        with_input_io do |io|
          parser = RequestLogAnalyzer::Source::LogParser.new(file_format)
          parser.parse_stream(io) do |req|
            yield request_to_tuple(req)
          end
        end
      end
      
      private
      
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
      
      ::Alf::Reader.register(:log, [".log"], self)
    end # class Reader
    
  end # module Logs
end # module Alf