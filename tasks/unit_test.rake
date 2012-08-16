begin
  require "rspec/core/rake_task"
  desc "Run RSpec code examples"
  RSpec::Core::RakeTask.new(:unit_test) do |t|
    # Glob pattern to match files.
    t.pattern = "spec/unit/**/test_*.rb"

    # Whether or not to fail Rake when an error occurs (typically when 
    # examples fail).
    t.fail_on_error = true

    # A message to print to stderr when there are failures.
    t.failure_message = nil

    # Use verbose output. If this is set to true, the task will print the
    # executed spec command to stdout.
    t.verbose = true

    # Use rcov for code coverage?
    t.rcov = false

    # Path to rcov.
    t.rcov_path = "rcov"

    # Command line options to pass to rcov. See 'rcov --help' about this
    t.rcov_opts = []

    # Command line options to pass to ruby. See 'ruby --help' about this 
    t.ruby_opts = []

    # Path to rspec
    t.rspec_path = "rspec"

    # Command line options to pass to rspec. See 'rspec --help' about this
    t.rspec_opts = ["--color", "--backtrace", "--format=d"]
  end
rescue LoadError => ex
  task :unit_test do
    abort 'rspec is not available. In order to run spec, you must: gem install rspec'
  end
ensure
  task :spec => [:unit_test]
  task :test => [:unit_test]
end
