# frozen_string_literal: true

require "csv"

module FlatJobs
  class Job
    attr_reader :company, :id, :title, :url, :location, :notes

    def initialize(company:, id:, title:, url:, location:, notes:)
      @company = company
      @id = id
      @title = title
      @url = url
      @location = location
      @notes = notes
    end

    def to_csv
      to_a.to_csv
    end

    private

    def to_a
      [company, id, title, location, url, notes]
    end
  end
end
