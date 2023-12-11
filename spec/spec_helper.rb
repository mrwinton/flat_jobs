require "support/coverage"
require "bundler/setup"
require "flat_jobs"
require "webmock/rspec"
require "vcr"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.configure_rspec_metadata!
  c.default_cassette_options = {serialize_with: :syck}
  c.hook_into :webmock
end

def vcr_response_data(vcr:)
  vcr_interactions_from(vcr:).map { |i| i.response.body }
end

def vcr_interactions_from(vcr:)
  hashes = YAML.load_file(File.join(Dir.pwd, "spec", "cassettes", "#{vcr}.yml"))["http_interactions"]
  hashes.map { |h| VCR::HTTPInteraction.from_hash(h) }
end
