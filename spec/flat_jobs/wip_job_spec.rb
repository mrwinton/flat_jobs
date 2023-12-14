# frozen_string_literal: true

RSpec.describe FlatJobs::WipJob do
  describe "#to_csv" do
    it "returns the wip job as a CSV string" do
      job = FlatJobs::WipJob.new(
        company: "Company",
        count: 3
      )

      result = job.to_csv

      expect(result).to eq("Company,-,-,-,-,3 jobs found\n")
    end
  end
end