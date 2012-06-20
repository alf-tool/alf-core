source 'http://rubygems.org'

group :runtime do
  gem "quickl", "~> 0.4.3"
  gem "myrrha", "~> 1.2.2"
  gem "backports", "~> 2.6"
end

group :test do
  gem "rake", "~> 0.9.2"
  gem "rspec", "~> 2.10"
end

group :release do
  gem "rake", "~> 0.9.2"
  gem "rspec", "~> 2.10"
  gem "wlang", "~> 0.10.2"
end

group :doc do
  gem "yard", "~> 0.8.2"
  gem "bluecloth", "~> 2.2.0"
  gem "redcarpet", "~> 2.1.0"
end

group :extra do
  gem "fastercsv", "~> 1.5"
  gem "request-log-analyzer", "~> 1.12.2"
  gem "sequel", "~> 3.36"
  gem "highline", "~> 1.6"
end

platform 'jruby' do
  group :extra do
    gem "jdbc-sqlite3", "~> 3.7"
  end
end
platform 'mri' do
  group :extra do
    gem "sqlite3", "~> 1.3"
  end
end