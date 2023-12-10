# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in flat-jobs.gemspec
gemspec

gem "activesupport"
gem "faraday"
gem "nokogiri"
gem "rake", "~> 13.0"

group :test, :development do
  gem "standard", "~> 1.3"
end

group :test do
  gem "fakefs"
  gem "rspec", "~> 3.0"
  gem "simplecov", require: false
  gem "vcr"
  gem "webmock"
end
