# frozen_string_literal: true

RSpec.describe FlatJobs::Job do
  describe "#to_csv" do
    it "returns the job as a CSV string" do
      job = FlatJobs::Job.new(
        company: "Company",
        id: 1,
        title: "Staff Engineer",
        location: "Remote",
        url: "http://example.com",
        notes: "Notes"
      )

      result = job.to_csv

      expect(result).to eq("Company,1,Staff Engineer,Remote,http://example.com,Notes\n")
    end
  end
end
