require 'spec_helper'
module Alf
  class Predicate
    describe Grammar, 'parse' do

      let(:source){ "x < 2" }

      subject{ Grammar.parse(source) }

      it{ should be_a(Sexpr) }

      it{ should be_a(Native) }

      specify{
        subject.proc.should be_a(Proc)
      }

      specify{
        subject.to_ruby_code.should eq("->{ x < 2 }")
      }

    end
  end
end