# frozen_string_literal: true

require "benchmark"

module FlatJobs
  class Update
    def self.call(...)
      new(...).call
    end

    def initialize(companies: FlatJobs::COMPANIES, io: $stdout)
      @companies = companies
      @io = io
    end

    def call
      benchmark = Benchmark.measure do
        update_companies
      end

      log("Processed #{companies.count} companies in #{benchmark.total}")
    end

    private

    attr_reader :companies, :io

    def update_companies
      FlatJobs::FileHelper.remove_files
      data = companies.map { |key, company| update_company(key, company) }.compact.join("\n")
      FlatJobs::FileHelper.save_file("flat_jobs", data, data_layer: DataLayer::GOLD, file_type: FileType::CSV)
    end

    def update_company(key, company)
      result = company.update if company.enabled?

      if company.enabled? && result.success?
        log("- #{key}: #{result.value.lines.count} job(s)")

        result.value
      elsif company.enabled? && result.failure?
        log("- #{key}: #{result.value}")
      else
        log("- #{key}: disabled")
      end
    end

    def log(message)
      io.puts(message)
    end
  end
end
