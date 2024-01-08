# frozen_string_literal: true

require "csv"

module FlatJobs
  class Job
    ATTRS = %i[company id title location url notes]

    attr_reader(*ATTRS)

    def initialize(company:, id:, title:, url:, location:, notes:)
      @company = company
      @id = sanitize(id)
      @title = sanitize(title)
      @url = sanitize(url)
      @location = sanitize(location)
      @notes = sanitize(notes)
    end

    def to_csv
      to_a.to_csv
    end

    def self.keys
      ATTRS.to_csv
    end

    private

    def sanitize(value)
      value&.to_s&.squish
    end

    def to_a
      ATTRS.map do |attr|
        instance_variable_get(:"@#{attr}")
      end
    end
  end
end
