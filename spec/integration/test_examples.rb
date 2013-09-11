require 'spec_helper'
Path.backfind("examples").glob("**/*.alf").each do |file|

  describe "Alf example: #{file}" do
    let(:example_path){ file }
    let(:example_dir) { file.parent }
    let(:example_db)  { Alf.connect(example_dir) }

    let(:source){ example_path.read }

    context 'when compiled through Connection#compile' do
      subject{
        example_db.compile(example_db.parse(source))
      }

      it_should_behave_like "a traceable cog"
    end

    context 'when compiled through #to_cog' do
      subject{
        example_db.parse(source).to_cog
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