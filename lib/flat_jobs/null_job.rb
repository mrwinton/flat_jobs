# frozen_string_literal: true

require "csv"

module FlatJobs
  class NullJob
    attr_reader :company, :count

    def initialize(company:, count:)
      @company = company
      @count = count
    end

    def to_csv
      to_a.to_csv
    end

    private

    def to_a
      company_index = FlatJobs::Job::ATTRS.index(:company)
      notes_index = FlatJobs::Job::ATTRS.index(:notes)

      Array.new(FlatJobs::Job::ATTRS.count) { "-" }.tap do |array|
        array[company_index] = company
        array[notes_index] = "#{count} jobs found"
      end
    end
  end
end
