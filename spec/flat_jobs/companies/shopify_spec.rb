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

      expect { FlatJobs::Companies::Shopify.new.parse_jobs(data) }.not_to raise_error
    end

    it "raises an error when jobs are returned" do
      data = <<~JSON
        {
          "result": null,
          "postings": [{"id": 1}, {"id": 2}],
          "flow": "default"
        }
      JSON

      expect { FlatJobs::Companies::Shopify.new.parse_jobs(data) }.to raise_error(FlatJobs::Error, "Job postings are up")
    end
  end
end
