# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

UPDATE = lambda do
  require_relative "lib/flat_jobs"
  FlatJobs.update
end

desc "Update FlatJobs"
task :update do
  puts UPDATE.call
end

RSpec::Core::RakeTask.new(:spec)
require "standard/rake"

ENV["COVERAGE"] = "1"
task default: %i[spec standard]

task test: %i[spec standard]
