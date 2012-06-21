require 'spec_helper'
Dir["#{File.expand_path('../../../examples', __FILE__)}/**/*.alf"].each do |file|

  describe "Alf example: #{file}" do
    let(:example_path){ file }
    let(:example_dir) { File.dirname(file) }
    let(:example_db) { Alf::Database.folder(example_dir) }

    it "should run without error" do
      example_db.compile(File.read(example_path), example_path).to_rel
    end

  end

end