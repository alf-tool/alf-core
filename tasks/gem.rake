require 'rubygems/package_task'
gemspec_file = File.expand_path('../../alf-core.gemspec', __FILE__)
gemspec      = Kernel.eval(File.read(gemspec_file))
Gem::PackageTask.new(gemspec) do |t|
  t.name = gemspec.name
  t.version = gemspec.version
  t.package_files = gemspec.files
end
