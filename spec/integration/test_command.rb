require 'spec_helper'
describe "Alf's alf command / " do

  Dir[_('command/**/*.cmd', __FILE__)].each do |input|
    cmd = File.readlines(input).first
    specify{ cmd.should =~ /^alf / }
  
    describe "#{File.basename(input)}: #{cmd}" do
      let(:argv)     { cmd =~ /^alf (.*)/; parse_commandline_args($1) }
      let(:stdout)   { File.join(File.dirname(input), "#{File.basename(input, ".cmd")}.stdout") }
      let(:expected) { File.read(stdout).gsub(/\$\(([\S]+)\)/){ Kernel.eval($1) } }

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
          Alf::Command::Main.run(argv, __FILE__)
        rescue SystemExit
          $stdout << SystemExit << "\n"
        end
        $stdout.string.should(eq(expected)) unless RUBY_VERSION < "1.9"
      }
    end
  end
    
end