# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"


RSpec::Core::RakeTask.new(:spec)
require "standard/rake"

ENV["COVERAGE"] = "1"
task default: %i[spec standard]
