require 'spec_helper'
Dir["#{File.expand_path('../../../examples', __FILE__)}/**/*.alf"].each do |file|

  describe "Alf example: #{file}" do
    let(:example_path){ file }
    let(:example_dir) { File.dirname(file) }
    let(:example_db) { Alf.connect(example_dir) }

    let(:source){ File.read(example_path) }

    context 'when compiled' do
      subject{
        example_db.compile(example_db.parse(source))
      }

      it_should_behave_like "a traceable cog"
    end

    context 'when queried' do
      subject{
        example_db.query(source, example_path)
      }
      
      it "should run without error" do
        subject.should be_a(Relation)
      end
    end
  end

end