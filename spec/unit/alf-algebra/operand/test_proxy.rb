require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Proxy do

        DELEGATED = [ :heading, :keys ]

        subject{
          Proxy.new(victim).send(method)
        }

        DELEGATED.each do |method|
          context "with #{method} with knowing victim" do
            let(:method){
              method
            }
            let(:victim){
              Struct.new(method).new("foo")
            }

            before do
              victim.should respond_to(method)
            end

            it "should delegate it" do
              subject.should eq("foo")
            end
          end

          context "with #{method} with knowing victim" do
            let(:method){
              method
            }
            let(:victim){
              Object.new
            }

            before do
              victim.should_not respond_to(method)
            end

            it "should raise a NotSupportedError" do
              lambda{
                subject
              }.should raise_error(NotSupportedError)
            end
          end
        end

      end
    end
  end
end
