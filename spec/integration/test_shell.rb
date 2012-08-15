require 'spec_helper'
describe "Alf's alf command / " do

  Path.relative('shell').glob('**/*.cmd').each do |input|
    cmd = wlang(input.readlines.first, binding)
    specify{ cmd.should =~ /^alf / }
  
    describe "#{input.basename}: #{cmd}" do
      let(:argv)            { Quickl.parse_commandline_args(cmd)[1..-1] }
      let(:stdout)          { input.sub_ext('.stdout') }
      let(:stderr)          { input.sub_ext('.stderr') }
      let(:stdout_expected) { stdout.exists? ? wlang(stdout.read, binding) : "" }
      let(:stderr_expected) { stderr.exists? ? wlang(stderr.read, binding) : "" }

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
          dir = Path.relative('__database__')
          main = Alf::Shell::Main.new
          main.database = Alf.connect(dir)
          main.run(argv, __FILE__)
        rescue => ex
          begin
            Alf::Shell::Main.handle_error(ex, main)
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
