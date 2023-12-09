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
end

require "flat_jobs/version"
require "flat_jobs/file_helper"
require "flat_jobs/client"
require "flat_jobs/job"
