require 'spec_helper'
describe "Alf's alf command" do

  let(:path){ _('../../bin/alf', __FILE__) }
  subject{ 
    `#{path} #{args}`
  }
  
  Dir[_('command/**/*.cmd', __FILE__)].each do |input|
    cmd = File.readlines(input).first

    specify{ cmd.should =~ /^alf / }
  
    describe cmd do
      let(:args)     { cmd =~ /^alf (.*)/; $1; }
      let(:stdout)   { File.join(File.dirname(input), "#{File.basename(input, ".cmd")}.stdout") }
      let(:expected) { File.read(stdout) }
      it{ should eq(expected) }
    end
  end
    
end