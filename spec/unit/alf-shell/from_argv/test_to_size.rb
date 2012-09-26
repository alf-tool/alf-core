require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, Size)" do

    subject{ Shell.from_argv(argv, Size) }

    context 'on an empty array' do
      let(:argv){ [ ] }
      it{ should eq(0) }
    end

    context 'with a single string' do
      let(:argv){ [ "12" ] }
      it{ should eq(12) }
    end

    context 'on a big array' do
      let(:argv){ ["12", "hello"] }
      specify{
        lambda{ subject }.should raise_error(Myrrha::Error)
      }
    end

    context 'when not coercable' do
      let(:argv){ ["hello"] }
      specify{ 
        lambda{ subject }.should raise_error(Myrrha::Error)
      }
    end

  end
end
