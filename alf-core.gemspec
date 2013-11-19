$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require "alf/core/version"
$version = Alf::Core::Version.to_s

Gem::Specification.new do |s|
  s.name = "alf-core"
  s.version = $version
  s.summary = "Relational Algebra at your fingertips"
  s.description = "Alf brings the relational algebra both in Shell and in Ruby. In Shell, because\nmanipulating any relation-like data source should be as straightforward as a\none-liner. In Ruby, because I've never understood why programming languages\nprovide data structures like arrays, hashes, sets, trees and graphs but not\n_relations_... Let's stop the segregation ;-)"
  s.homepage = "http://blambeau.github.com/alf"
  s.authors = ["Bernard Lambeau"]
  s.email  = ["blambeau@gmail.com"]
  s.require_paths = ['lib']
  here = File.expand_path(File.dirname(__FILE__))
  s.files = File.readlines(File.join(here, 'Manifest.txt')).
                 inject([]){|files, pattern| files + Dir[File.join(here, pattern.strip)]}.
                 collect{|x| x[(1+here.size)..-1]}


  s.add_development_dependency("rake", "~> 10.1")
  s.add_development_dependency("rspec", "~> 2.14")
  s.add_development_dependency("highline", "~> 1.6")
  s.add_development_dependency("ruby_cop", "~> 1.0")
  s.add_dependency("myrrha", "~> 3.0")
  s.add_dependency("domain", "~> 1.0")
  s.add_dependency("path", "~> 1.3")
  s.add_dependency("sexpr", "~> 0.6.0")

end
