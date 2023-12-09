# frozen_string_literal: true

module FlatJobs
  # Exception class for exceptions raised by FlatJobs.
  class Error < StandardError; end

  # Supported data layers, inspo from medallian data architecture
  module DataLayer
    BRONZE = :bronze
    SILVER = :silver
    GOLD = :gold
  end

  # Supported file types
  module FileType
    CSV = "csv"
    HTML = "html"
    JSON = "json"
  end

  # Hash where companies are registered. Maps company (name) key to company.
  # Each company is a class that responds to +update+ that then updates the
  # company's data, parses any jobs, and saves the jobs to `/data`.
  COMPANIES = {}

  def self.register_company(key, company)
    COMPANIES[key] = company
  end
end

require "active_support"
require "active_support/all"

require "flat_jobs/version"
require "flat_jobs/result"
require "flat_jobs/file_helper"
require "flat_jobs/client"
require "flat_jobs/job"
require "flat_jobs/company"
Dir.glob(Dir.pwd + "/lib/flat_jobs/companies/*.rb").each { |file| require file }
