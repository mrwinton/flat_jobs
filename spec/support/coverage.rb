return unless ENV["COVERAGE"]

require "simplecov"

SimpleCov.start { enable_coverage :branch }
SimpleCov.minimum_coverage line: 100, branch: 100
