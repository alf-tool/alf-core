require 'spec_helper'
module Alf
  describe Environment do

    describe "autodetect" do

      it "should support an Environment instance" do
        env = Environment.examples
        Environment.autodetect(env).should eq(env)
      end

      it "should recognize an existing folder" do
        env = Environment.autodetect(File.dirname(__FILE__))
        env.should be_a(Environment::Folder)
      end

      it "should recognize a sqlite file" do
        env = Environment.autodetect(_("sequel/alf.db", __FILE__))
        env.should be_a(Sequel::Environment)
      end

      it "should raise an Argument when no match" do
        lambda{ Environment.autodetect(12) }.should raise_error(ArgumentError)
      end

      it "should be aliased as coerce" do
        env = Environment.examples
        Environment.coerce(env).should eq(env)
        Environment.coerce(File.dirname(__FILE__)).should be_a(Environment::Folder)
      end

    end # autodetect

  end
end
