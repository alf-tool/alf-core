require 'spec_helper'
describe :instance_eval do

  let(:bar){ lambda{10} }
  let(:foo) { Object.new }

  if RUBY_VERSION <= "1.9"
    subject{ foo.instance_eval(&bar) }
    it { should == 10 }
  else
    subject{ foo.instance_exec(&bar) }
    it { should == 10 }
  end

end
