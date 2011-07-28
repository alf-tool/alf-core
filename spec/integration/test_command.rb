require 'spec_helper'
describe "Alf's alf command / " do

  Dir[_('command/**/*.cmd', __FILE__)].each do |input|
    cmd = wlang(File.readlines(input).first, binding)
    specify{ cmd.should =~ /^alf / }
  
    describe "#{File.basename(input)}: #{cmd}" do
      let(:argv)     { Alf::Tools::parse_commandline_args(cmd)[1..-1] }
      let(:stdout)   { File.join(File.dirname(input), "#{File.basename(input, ".cmd")}.stdout") }
      let(:expected) { wlang(File.read(stdout), binding) }

      before{ 
        $oldstdout = $stdout 
        $stdout = StringIO.new
      }
      after { 
        $stdout = $oldstdout
        $oldstdout = nil 
      }
      
      specify{
        begin 
          dir = File.expand_path('../__database__', __FILE__)
          main = Alf::Command::Main.new
          main.environment = Alf::Environment.folder(dir)
          main.run(argv, __FILE__)
        rescue Quickl::Exit
          $stdout << SystemExit << "\n"
        end
        $stdout.string.should(eq(expected)) unless RUBY_VERSION < "1.9"
      }
    end
  end
    
end
