# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Github do
  describe "#fetch_data", vcr: "github_data" do
    it "returns data" do
      result = FlatJobs::Companies::Github.new.fetch_data

      expect(result).not_to be_empty
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Github.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::JSON)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      data = vcr_response_data(vcr: "github_data").first

      result = FlatJobs::Companies::Github.new.parse_jobs(data)

      expect(result.lines.count).not_to be_zero
      expect(result.lines.first).to match(/github,2431,"Senior Manager, Software Engineering",US Remote,https:\/\/careers-githubinc.icims.com\/jobs\/2431\/login,"About GitHub/)
    end
  end
end
