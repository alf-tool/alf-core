require 'spec_helper'
describe "Alf's alf command" do

  let(:path){ _('../../bin/alf', __FILE__) }
  
  Dir[_('command/**/*.cmd', __FILE__)].each do |input|
    cmd = File.readlines(input).first

    specify{ cmd.should =~ /^alf / }
  
    describe cmd do
      let(:args)     { cmd =~ /^alf (.*)/; $1; }
      let(:stdout)   { File.join(File.dirname(input), "#{File.basename(input, ".cmd")}.stdout") }
      let(:expected) { File.read(stdout) }
      specify{ 
        result = `#{path} #{args}`
        $?.exitstatus.should == 0 
        result.should(eq(expected)) unless RUBY_VERSION < "1.9"
      }
    end
  end
    
end