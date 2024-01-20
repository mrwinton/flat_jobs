# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Gitlab do
  describe "#fetch_data", vcr: "gitlab_data" do
    it "returns data" do
      result = FlatJobs::Companies::Gitlab.new.fetch_data

      expect(result).not_to be_empty
    end

    it "returns nil when no data element is found" do
      result = FlatJobs::Companies::Gitlab.new.fetch_data(data_path: "random_path")

      expect(result).to be_nil
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Gitlab.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::HTML)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      data = vcr_response_data(vcr: "gitlab_data").first

      result = FlatJobs::Companies::Gitlab.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("gitlab")
      expect(job.id).to eq("6831303002")
      expect(job.title).to eq("Support Engineer (US Federal)")
      expect(job.url).to eq("https://boards.greenhouse.io/gitlab/jobs/6831303002")
      expect(job.location).to eq("Remote, Americas")
      expect(job.notes).to be_empty
    end
  end
end
