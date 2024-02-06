# frozen_string_literal: true

RSpec.describe FlatJobs::NullJob do
  describe "#id" do
    it "returns `nil`" do
      company = "company"
      notes = "3 jobs found"
      job = FlatJobs::NullJob.new(
        company: company,
        notes: notes
      )

      result = job.id

      expect(result).to eq(nil)
    end
  end

  describe "#to_csv" do
    it "returns the wip job as a CSV string" do
      company = "company"
      notes = "3 jobs found"
      job = FlatJobs::NullJob.new(
        company: company,
        notes: notes
      )

      result = job.to_csv

      expect(result).to eq("#{company},-,-,-,-,#{notes}\n")
    end
  end
end
