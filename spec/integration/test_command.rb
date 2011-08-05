require 'spec_helper'
describe "Alf's alf command / " do

  Dir[_('command/**/*.cmd', __FILE__)].each do |input|
    cmd = wlang(File.readlines(input).first, binding)
    specify{ cmd.should =~ /^alf / }
  
    describe "#{File.basename(input)}: #{cmd}" do
      let(:argv)     { Quickl.parse_commandline_args(cmd)[1..-1] }
      let(:stdout)   { File.join(File.dirname(input), "#{File.basename(input, ".cmd")}.stdout") }
      let(:stderr)   { File.join(File.dirname(input), "#{File.basename(input, ".cmd")}.stderr") }
      let(:stdout_expected) { File.exists?(stdout) ? wlang(File.read(stdout), binding) : "" }
      let(:stderr_expected) { File.exists?(stderr) ? wlang(File.read(stderr), binding) : "" }

      before{ 
        $oldstdout = $stdout 
        $oldstderr = $stderr
        $stdout = StringIO.new
        $stderr = StringIO.new
      }
      after { 
        $stdout = $oldstdout
        $stderr = $oldstderr
        $oldstdout = nil 
        $oldstderr = nil 
      }
      
      specify{
        begin 
          dir = File.expand_path('../__database__', __FILE__)
          main = Alf::Command::Main.new
          main.environment = Alf::Environment.folder(dir)
          main.run(argv, __FILE__)
        rescue => ex
          begin
            Alf::Command::Main.handle_error(ex, main)
          rescue SystemExit
            $stdout << "SystemExit" << "\n"
          end
        end
        $stdout.string.should(eq(stdout_expected)) unless RUBY_VERSION < "1.9"
        $stderr.string.should(eq(stderr_expected)) unless RUBY_VERSION < "1.9"
      }
    end
  end
    
end
