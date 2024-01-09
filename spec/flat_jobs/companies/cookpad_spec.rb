# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Cookpad do
  describe "#fetch_data", vcr: "cookpad_data" do
    it "returns data" do
      result = FlatJobs::Companies::Cookpad.new.fetch_data

      expect(result).not_to be_empty
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Cookpad.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::JSON)
    end
  end

  describe "#parse_jobs" do
    it "reports jobs count" do
      data = vcr_response_data(vcr: "cookpad_data").first

      result = FlatJobs::Companies::Cookpad.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("cookpad")
      expect(job.notes).to eq("0 jobs found")
    end
  end
end
