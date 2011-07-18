require 'spec_helper'
Dir["#{File.expand_path('../../../examples', __FILE__)}/**/*.alf"].each do |file|

  describe "Alf example: #{file}" do
    let(:example_path){ file }
    let(:example_dir) { File.dirname(file) }
    let(:example_env) { Alf::Environment.folder(example_dir) }

    it "should run without error" do
      Alf.lispy(example_env).compile(File.read(example_path), example_path).to_rel
    end

  end

end