require "bundler/gem_tasks"
require 'rake'
require 'rake/testtask'

# environment
ENV['RACK_ENV'] ||= 'development'

# load path
lib_path = File.expand_path('../lib', __FILE__)
($:.unshift lib_path) unless ($:.include? lib_path)

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
end
task :default => [:test]
