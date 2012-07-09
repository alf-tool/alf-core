require 'spec_helper'
module Alf
  module Shell
    describe DocManager, ".call" do

      let(:dm){ @dm ||= DocManager.new }
      let(:cmd){ Alf::Shell::Show }
      subject{
        dm.call(cmd, {})
      }

      describe "on a static file" do
        before{
          def dm.find_file(cmd);
            File.expand_path('../static.md', __FILE__)
          end
        }
        it { should eq("Hello\n") }
      end

      describe "on a dynamic file" do
        before{
          def dm.find_file(cmd);
            File.expand_path('../dynamic.md', __FILE__)
          end
        }
        it { should eq("show\n") }
      end

      unless RUBY_VERSION < "1.9"
        describe "on an example file" do
          before{
            def dm.find_file(cmd);
              File.expand_path('../example.md', __FILE__)
            end
          }
          it { should eq(File.read(File.expand_path('../example_1.txt', __FILE__))) }
        end
      end

    end
  end
end
