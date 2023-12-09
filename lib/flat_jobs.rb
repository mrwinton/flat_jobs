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
end

require "flat_jobs/version"
require "flat_jobs/client"
require "flat_jobs/job"
