# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Thoughtbot do
  describe "#fetch_data", vcr: "thoughtbot_data" do
    it "returns data" do
      result = FlatJobs::Companies::Thoughtbot.new.fetch_data

      expect(result).not_to be_empty
    end

    it "returns nil when no data element is found" do
      result = FlatJobs::Companies::Thoughtbot.new.fetch_data(data_path: "random_path")

      expect(result).to be_nil
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Thoughtbot.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::HTML)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      data = vcr_response_data(vcr: "thoughtbot_data").first

      result = FlatJobs::Companies::Thoughtbot.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("thoughtbot")
      expect(job.id).to eq("business-development-manager-europe-west-asia-and-africa-3CD3B6F5E4")
      expect(job.title).to eq("Business Development Manager (Europe, West Asia, and Africa)")
      expect(job.url).to eq("https://thoughtbot.com/jobs/business-development-manager-europe-west-asia-and-africa-3CD3B6F5E4")
      expect(job.location).to eq("Europe, West Asia, Africa")
      expect(job.notes).to be_empty
    end
  end
end
