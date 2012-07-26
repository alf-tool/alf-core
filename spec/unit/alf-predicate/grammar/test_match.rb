require 'spec_helper'
module Alf
  class Predicate
    describe Grammar, 'match?' do

      context "tautology" do
        subject{ Grammar[:tautology] }

        it 'matches a tautology' do
          subject.should be_match([:tautology, true])
        end
        it 'does no match a wrong one' do
          subject.should_not be_match([:tautology, false])
        end
      end

      context "contradiction" do
        subject{ Grammar[:contradiction] }

        it 'matches a tautology' do
          subject.should be_match([:contradiction, false])
        end
        it 'does no match a wrong one' do
          subject.should_not be_match([:contradiction, true])
        end
      end

      context "var_ref" do
        subject{ Grammar[:var_ref] }

        it 'matches a valid ast' do
          subject.should be_match([:var_ref, :id])
        end

        it 'does not match an invalid ast' do
          subject.should_not be_match([:var_ref, 12])
        end
      end

      context "literal" do
        subject{ Grammar[:literal] }

        it 'matches valid ASTs' do
          subject.should be_match([:literal, 12])
          subject.should be_match([:literal, true])
        end
      end

      context "eq" do
        subject{ Grammar[:eq] }

        it 'matches valid ASTs' do
          subject.should be_match([:eq, [:var_ref, :age], [:literal, 12]])
        end
        it 'does not match invalid ASTs' do
          subject.should_not be_match([:neq, [:var_ref, :age], [:literal, 12]])
        end
      end

      context "neq" do
        subject{ Grammar[:neq] }

        it 'matches valid ASTs' do
          subject.should be_match([:neq, [:var_ref, :age], [:literal, 12]])
        end
        it 'does not match invalid ASTs' do
          subject.should_not be_match([:eq, [:var_ref, :age], [:literal, 12]])
        end
      end

      context "native" do
        subject{ Grammar[:native] }

        it 'matches valid ASTs' do
          subject.should be_match([:native, lambda{}])
        end
        it 'does not match invalid ASTs' do
          subject.should_not be_match([:native, 12])
        end
      end

    end
  end
end
