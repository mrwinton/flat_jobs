# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Fly do
  describe "#fetch_data", vcr: "fly_data" do
    it "returns data" do
      result = FlatJobs::Companies::Fly.new.fetch_data

      expect(result).not_to be_empty
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Fly.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::HTML)
    end
  end

  describe "#parse_jobs" do
    it "returns jobs" do
      data = vcr_response_data(vcr: "fly_data").first

      result = FlatJobs::Companies::Fly.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("fly")
      expect(job.id).to eq("customer-success-manager")
      expect(job.title).to eq("Engineering - Customer Success Manager")
      expect(job.url).to eq("https://fly.io/jobs/customer-success-manager/")
      expect(job.location).to eq("Anywhere")
      expect(job.notes).to eq("")
    end
  end
end
