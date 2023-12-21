# frozen_string_literal: true

RSpec.describe FlatJobs::Companies::Shopify do
  describe "#fetch_data", vcr: "shopify_data" do
    it "returns data" do
      result = FlatJobs::Companies::Shopify.new.fetch_data

      expect(result).not_to be_empty
    end
  end

  describe "#data_file_type" do
    it "returns expected file type" do
      result = FlatJobs::Companies::Shopify.new.data_file_type

      expect(result).to eq(FlatJobs::FileType::JSON)
    end
  end

  describe "#parse_jobs" do
    it "does not raise error when no jobs are returned" do
      data = vcr_response_data(vcr: "shopify_data").first

      result = FlatJobs::Companies::Shopify.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("shopify")
      expect(job.notes).to eq("0 jobs found")
    end

    it "raises an error when jobs are returned" do
      data = <<~JSON
        {
          "result": null,
          "postings": [{"id": 1}, {"id": 2}],
          "flow": "default"
        }
      JSON

      result = FlatJobs::Companies::Shopify.new.parse_jobs(data)

      expect(result.count).not_to be_zero
      job = result.first
      expect(job.company).to eq("shopify")
      expect(job.notes).to eq("2 jobs found")
    end
  end
end
