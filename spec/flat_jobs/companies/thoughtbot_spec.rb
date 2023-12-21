# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Thoughtbot do
  describe "#fetch_data", vcr: "thoughtbot_data" do
    it "returns data" do
      result = FlatJobs::Companies::Thoughtbot.new.fetch_data

      expect(result).not_to be_empty
    end

    it "raises an error when no data element is found" do
      expect do
        FlatJobs::Companies::Thoughtbot.new.fetch_data(data_path: "random_path")
      end.to raise_error(FlatJobs::Error, "Data element not found")
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Thoughtbot.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::HTML)
    end
  end

  describe "#parse_jobs" do
    it "reports 0 jobs when no jobs are returned" do
      data = vcr_response_data(vcr: "thoughtbot_data").first

      result = FlatJobs::Companies::Thoughtbot.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("thoughtbot")
      expect(job.notes).to eq("0 jobs found")
    end

    it "reports jobs when no-jobs-message is not found" do
      data = "We have open positions"

      result = FlatJobs::Companies::Thoughtbot.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("thoughtbot")
      expect(job.notes).to eq("1+ jobs found")
    end
  end
end
