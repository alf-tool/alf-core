require 'spec_helper'
module Alf
  describe Renderer do

    subject{ Renderer }

    let(:input){ [{:a => 1}] }

    it { should respond_to(:rash) }
    it { should respond_to(:text) }
    it { should respond_to(:csv)  }
    it { should respond_to(:yaml) }

    describe 'renderer' do
      subject{ Renderer.renderer(:rash, []) }

      it{ should be_a(Renderer) }
    end

    describe 'rash' do
      subject{ Renderer.rash(input) }

      it{ should be_a(Renderer::Rash) }
    end

    describe 'rash --pretty' do
      subject{ Renderer.rash(input, {pretty: true}) }

      it{ should be_a(Renderer::Rash) }

      it 'should have correct options' do
        subject.options.should eq(pretty: true)
      end
    end

    describe 'text' do
      subject{ Renderer.text(input) }

      it{ should be_a(Renderer::Text) }
    end

  end
end
