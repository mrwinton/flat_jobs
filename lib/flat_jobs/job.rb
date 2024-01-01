# frozen_string_literal: true

require "csv"

module FlatJobs
  class Job
    ATTRS = %i[company id title location url notes]

    attr_reader(*ATTRS)

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

    def self.keys
      ATTRS.to_csv
    end

    private

    def to_a
      ATTRS.map do |attr|
        instance_variable_get(:"@#{attr}")
      end
    end
  end
end
