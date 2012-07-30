require 'spec_helper'
module Alf
  describe "Reader#initialize" do

    subject{ Reader.new(*args) }

    let(:input){ nil }
    let(:context){ nil }
    let(:options){ nil }

    let(:args){ [input, context, options].compact }

    before do
      subject.should be_a(Reader)
    end

    after do
      subject.input.should eq(input)
      subject.context.should eq(context)
    end

    context 'with empty default options' do

      after do
        subject.options.should eq(options || {})
      end

      context "with only a path as a String" do
        let(:input){ "suppliers" }
        it 'should set the path correctly' do
          subject.path.should eq(Path("suppliers"))
        end
      end

      context "with only a path as a Path" do
        let(:input){ Path("suppliers") }
        it 'should set the path correctly' do
          subject.path.should eq(Path("suppliers"))
        end
      end

      context "with a File" do
        let(:input){ Path.here.open('r') }
        it 'should set the path correctly' do
          subject.path.should eq(Path.here)
        end
        after{ input.close rescue nil }
      end

      describe "with full args" do
        let(:input){ "suppliers" }
        let(:context){ Connection.folder Path.backfind('examples/operators') }
        let(:options){ {:opts => true} }
        it 'should set the path correctly' do
          subject.path.should eq(Path("suppliers"))
        end
      end

    end

    describe "on a subclass" do
      class FooReader < Reader
        DEFAULT_OPTIONS = {:from => :subclass}
      end
      subject{ FooReader.new(*args) }

      let(:input){ "suppliers" }

      describe "without option overriding" do
        let(:options){ {:opts => true} }
        it 'should merge options' do
          subject.options.should eq(:opts => true, :from => :subclass)
        end
      end

      describe "with option overriding" do
        let(:options){ {:opts => true, :from => :overrided} }
        it 'should override options' do
          subject.options.should eq(:opts => true, :from => :overrided)
        end
      end

    end

  end
end